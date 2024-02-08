class_name WebsocketInteractor extends RichTextLabel

## This script maintains communications to the Python backend. 
## It connects to the websocket server run by the backend and parses its messages.
## After parsing, the relevant signal gets emitted with the parsed data.

@export var websocket_url: String = "ws://localhost:9001" ## The URL of the websocket. Can be adjusted in the inspector.
var _socket := WebSocketPeer.new()
var _connection_attempt_timer: float = 0
var _connection_attempt_interval: float = 1  # 1 second
var play: bool = true ## Interacts with the play/pause button on the GUI. [color=palevioletred]false[/color] prevents signals from being emitted.

signal BodyReceived(receivedLandmarks: Array[Dictionary])
signal RulaReceived(leftScore: int, rightScore: int)
signal OwasReceived(postureCode: Dictionary)
signal AnalysisReceived(results: Dictionary)



func _ready():
	_socket.connect_to_url(websocket_url)
	text = "Trying to connect to backend"

## The websocket is polled every frame for new messages. If any are received, they will be parsed and the data will be forwarded to the appropriate signal.
func _process(_delta):
	_socket.poll()
	var state := _socket.get_ready_state()
	_connection_attempt_timer += _delta
	if _connection_attempt_timer >= _connection_attempt_interval && state == WebSocketPeer.STATE_CONNECTING:
		_connection_attempt_timer = 0
		var count: int = int(Time.get_unix_time_from_system()) % 4
		var s: String = ""
		for i in count:
			s += "."
		print("Trying to connect")
		text = "Trying to connect to backend" + s
	
	if state == WebSocketPeer.STATE_OPEN:
		text = ""
		while _socket.get_available_packet_count():
			var packet := _socket.get_packet()
			var message := packetToString(packet)
			#print("Received message: ", message)
			var parsedArray: Array = Parser(message)
			var tag: String = parsedArray[0]
			var dictArray: Array[Dictionary] = parsedArray[1]
			if (dictArray.size() != 0 && play):
				if(tag == "Body" && dictArray.size() == 33):
					BodyReceived.emit(dictArray)
				elif(tag == "RULA"):
					RulaReceived.emit(dictArray[0]["left"], dictArray[0]["right"])
				elif(tag == "OWAS"):
					OwasReceived.emit(dictArray[0])
				elif(tag == "Langzeit"):
					AnalysisReceived.emit(dictArray[0])



## Takes a binary message and returns a string for parsing.
func packetToString(packet: PackedByteArray) -> String:
	var message: String = ""
	for i in range(packet.size()):
		message += char(packet[i])
	return message

## Parses the message string according to the protocol explained in [code]main.py[/code].
func Parser(message: String) -> Array:
	var msgArray: PackedStringArray = message.split("|");
	var dictArray: Array[Dictionary] = []
	if (msgArray.size() > 1):
		for i: int in range(1, msgArray.size()):
			var tempArr: PackedStringArray = msgArray[i].split("\n")
			var tempDict: Dictionary = {}
			for j in tempArr.size() if (msgArray[0] != "Body") else 4:
				var item: String = tempArr[j]
				var tuple: PackedStringArray = item.split(": ")
				tempDict[tuple[0]] = tuple[1]
			dictArray.append(tempDict)
	var returnArray: Array = [msgArray[0], dictArray]
	return returnArray
	


func _on_play_pause_button_up():
	play = !play


func _on_recording_button_button_up():
	_socket.send_text("recording")
	$"../Panel/Data panel/PanelContainer3".hide()
