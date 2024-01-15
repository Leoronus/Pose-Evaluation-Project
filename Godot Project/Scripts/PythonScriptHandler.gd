extends RichTextLabel

var pid: int = 0
@export var startBackend: bool = false
@export var showTerminal: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if(startBackend):
		pid = OS.create_process("python",["../main.py"], showTerminal)
		print(pid)
		if (pid == -1):
			text = "Failed to launch backend."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
