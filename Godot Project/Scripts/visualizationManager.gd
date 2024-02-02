class_name visualizationManager extends Node3D


var landmarks: Array[Node3D] ## Array of indicator nodes.
var landmarkTargets: Array[Vector3] ## Array of targets, to which the nodes are bound kind of elastically.
@export var sphereSize: float = 0.1 ## Scaling factor for all indicator spheres, adjustable from inspector.
@export var snapFactor: float = 0.8
var doneLoading: bool = false


func _ready():
	landmarkTargets.resize(33)
	for i: int in 33: # create indicators for the 33 landmarks
		var sphere: MeshInstance3D = MeshInstance3D.new() # create node
		sphere.mesh = SphereMesh.new() # assign generic sphere mesh
		sphere.name = "landmark " + str(i)
		var angle_rad: float = deg_to_rad(10 * i)
		sphere.transform.origin = Vector3(cos(angle_rad), sin(angle_rad), 0.0) # randomize each node's position, doesn't serve any real purpose
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere) # make new node a child of the visualization manager's node


func _process(delta):
	for i in 33: # update indicator sizes
		var sphere = landmarks[i]
		sphere.scale = Vector3(1,1,1) * sphereSize
		if doneLoading: sphere.transform.origin += (landmarkTargets[i] - landmarks[i].transform.origin) * snapFactor
	
	if(!doneLoading):
		rotation_degrees += Vector3(0, 0, -90 * delta)
	else:
		rotation_degrees = Vector3.ZERO


## Updates indicator positions. Must be connected to the bodyReceived signal.
func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	doneLoading = true
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarkTargets[i] = Vector3(mark["x"], mark["y"], mark["z"])
