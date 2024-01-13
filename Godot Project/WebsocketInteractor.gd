extends RichTextLabel

# The URL we will connect to
@export var websocket_url = "ws://localhost:9001"

var socket = WebSocketPeer.new()
var connection_attempt_timer: float = 0
var connection_attempt_interval: float = 1.0  # 1 second
signal BodyReceived(receivedLandmarks: Array[Dictionary])

func _ready():
	socket.connect_to_url(websocket_url)
	text = "Trying to connect to backend"

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	connection_attempt_timer += delta

	if connection_attempt_timer >= connection_attempt_interval && state == WebSocketPeer.STATE_CONNECTING:
		connection_attempt_timer = 0
		print("Trying to connect")
		
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			var message = packet_to_string(packet)
			print("Received message: ", message)
			var arr: Array[Dictionary] = Parser(message)
			if(arr.size() == 33):
				BodyReceived.emit(arr)

func packet_to_string(packet: PackedByteArray) -> String:
	var message: String = ""
	for i in range(packet.size()):
		message += char(packet[i])
	return message

func Parser(message: String) -> Array[Dictionary]:
	var msgArray: PackedStringArray = message.split("|");
	var returnArray: Array[Dictionary]
	if (msgArray[0] == "Body"):
		for i: int in range(1, msgArray.size()):
			var tempArr: PackedStringArray = msgArray[i].split("\n")
			var tempDict: Dictionary
			for j in 4:
				var item: String = tempArr[j]
				var tuple: PackedStringArray = item.split(": ")
				tempDict[tuple[0]] = float(tuple[1])
			returnArray.append(tempDict)
	return returnArray
	
