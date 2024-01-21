extends RichTextLabel

var pid: int = 0	## ProcessID for the backend
@export var startBackend: bool = false
@export var showTerminal: bool = true


func _ready():
	if(startBackend):
		pid = OS.create_process("python",["../main.py"], showTerminal)
		print(pid)
		if (pid == -1):
			text = "Failed to launch backend."


func _process(delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
