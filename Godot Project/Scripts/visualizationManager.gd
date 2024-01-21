class_name visualizationManager extends Node3D


var landmarks: Array[Node3D] ## Array of indicator nodes.
@export var sphereSize: float = 0.1 ## Scaling factor for all indicator spheres, adjustable from inspector


func _ready():
	var rng = RandomNumberGenerator.new()
	for i: int in 33: # create indicators for the 33 landmarks
		var sphere: MeshInstance3D = MeshInstance3D.new() # create node
		sphere.mesh = SphereMesh.new() # assign generic sphere mesh
		sphere.name = "landmark " + str(i)
		sphere.transform.origin = Vector3(rng.randf_range(-10, 10), rng.randf_range(-10, 10), 0.0) # randomize each node's position, doesn't serve any real purpose
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere) # make new node a child of the visualization manager's node


func _process(delta):
	for sphere in landmarks: # update indicator sizes
		sphere.scale = Vector3(1,1,1) * sphereSize


## Updates indicator positions. Must be connected to the bodyReceived signal.
func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarks[i].transform.origin = Vector3(mark["x"], mark["y"], mark["z"])
