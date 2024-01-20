extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_rula_received(leftScore, rightScore):
	text = "RULA left: " + str(leftScore) + "\nRULA right: " + str(rightScore)
