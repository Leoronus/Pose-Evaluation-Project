extends Node3D


var landmarks: Array[Node3D]
@export var sphereSize: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	for i: int in 33:
		var sphere: MeshInstance3D = MeshInstance3D.new()
		sphere.mesh = SphereMesh.new()
		sphere.name = "landmark " + str(i)
		sphere.transform.origin = Vector3(rng.randf_range(-10, 10), rng.randf_range(-10, 10), 0.0)
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for sphere in landmarks:
		sphere.scale = Vector3(1,1,1) * sphereSize

func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarks[i].transform.origin = Vector3(mark["x"], mark["y"], mark["z"])
