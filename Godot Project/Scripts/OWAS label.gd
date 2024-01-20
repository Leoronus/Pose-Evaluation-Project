extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_owas_received(postureCode):
	var pc: Dictionary = postureCode
	text = "back: " + str(pc["back"]) + "\narms: " + str(pc["arms"]) + "\nlegs: " + str(pc["legs"]) + "\nweight: " + str(pc["weight"])
