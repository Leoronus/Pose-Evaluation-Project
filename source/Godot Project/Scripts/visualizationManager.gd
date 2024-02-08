class_name visualizationManager extends Node3D
## Manages the 3D visualization of received landmarks.


var landmarks: Array[Node3D] ## Array of indicator nodes.
var landmarkTargets: Array[Vector3] ## Array of targets, to which the nodes are bound kind of elastically.
@export var sphereSize: float = 0.1 ## Scaling factor for all indicator spheres, adjustable from inspector.
@export var snapFactor: float = 0.1 ## controls the visualization's smoothing. At 1 the indicators immediately snap to their updated positions.
var _doneLoading: bool = false
## Array containing the indexes for each bone's landmarks.
var boneArray: Array[Array] = [\
		[0,2],[0,5],[2,7],\
		[5,8],[9,10],[11,12],\
		[11,13],[11,23],[12,14],\
		[12,24],[13,15],[14,16],\
		[15,17],[15,19],[15,21],\
		[16,18],[16,20],[16,22],\
		[17,19],[18,20],[23,24],\
		[23,25],[24,26],[25,27],\
		[26,28],[27,29],[27,31],\
		[28,30],[28,32],[29,31],\
		[30,32]\
		]
var _bones: Array[MeshInstance3D] = []


func _ready():
	landmarkTargets.resize(33)
	for i: int in 33: # create indicators for the 33 landmarks
		var sphere: MeshInstance3D = MeshInstance3D.new() # create node
		sphere.mesh = SphereMesh.new() # assign generic sphere mesh
		sphere.name = "landmark " + str(i)
		var angle_rad: float = deg_to_rad(10 * i)
		sphere.transform.origin = Vector3(cos(angle_rad), sin(angle_rad), 0.0)
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere) # make new node a child of the visualization manager's node


func _process(delta):
	for i in 33: # update indicator sizes
		var sphere = landmarks[i]
		sphere.scale = Vector3(1,1,1) * sphereSize
		var moveVec := (landmarkTargets[i] - landmarks[i].transform.origin) * snapFactor
		if (_doneLoading && moveVec.length() > 0.01): sphere.transform.origin += moveVec
	
	if(!_doneLoading):
		rotation_degrees += Vector3(0, 0, -90 * delta) #loading animation
	else:
		#var timespan: float = Time.get_unix_time_from_system()
		$"../Control/CanvasLayer/RecordingButton".init = true #enable recording
		rotation_degrees = Vector3.ZERO
		for bone in _bones: #delete old bones
			bone.queue_free()
		_bones.clear()
		for bonePair in boneArray: # draw new bones
			_bones.append(_line(landmarks[bonePair[0]].global_position, landmarks[bonePair[1]].transform.origin))
		
		#timespan = Time.get_unix_time_from_system() - timespan
		#print(timespan)


func _line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(mesh_instance)
	return mesh_instance


## Updates indicator positions. Must be connected to the bodyReceived signal.
func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	_doneLoading = true
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarkTargets[i] = Vector3(float(mark["x"]), float(mark["y"]), float(mark["z"]))
		landmarks[i].transparency = 1 - float(mark["visibility"])
