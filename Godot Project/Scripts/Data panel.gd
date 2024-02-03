extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer3.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_analysis_received(results):
	$PanelContainer3.show()
	#$PanelContainer2.hide()
	#$PanelContainer.hide()
	$"PanelContainer3/VBoxContainer/Analysis text".text = \
			"Back position: " + results["back_Position"] + \
			"\nBack action: " + results["back_Action"] + \
			"\n\nArms position: " + results["arms_Position"] + \
			"\nArms action: " + results["arms_Action"] + \
			"\n\nLegs position: " + results["legs_Position"] + \
			"\nLegs action: " + results["legs_Action"]
