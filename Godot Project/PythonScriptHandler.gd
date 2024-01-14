extends RichTextLabel

var pid: int
@export var showTerminal: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pid = OS.create_process("python",["C:/Users/Leon Wigro/Documents/GitHub/Pose-Evaluation-Project/main.dont"], showTerminal)
	print(pid)
	if (pid == -1):
		text = "Failed to launch backend."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
