extends Button

@export var icons: Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.disabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_websocket_interactor_body_received(receivedLandmarks):
	disabled = false


var currentIcon: int = 0
func _on_button_up():
	currentIcon = (currentIcon + 1) % 2;
	icon = icons[currentIcon]
