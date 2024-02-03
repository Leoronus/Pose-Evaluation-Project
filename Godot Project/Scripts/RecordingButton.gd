extends Button

@export var icons: Array[Texture2D]
var _initHidden: bool = false
var init: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (disabled && init && !_initHidden):
		disabled = false
		_initHidden = true


var currentIcon: int = 0
func _on_button_up():
	currentIcon = (currentIcon + 1) % 2;
	icon = icons[currentIcon]
	if currentIcon == 0:
		disabled = true
