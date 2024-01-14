extends RichTextLabel

# The URL we will connect to
@export var websocket_url = "ws://localhost:9001"

var socket = WebSocketPeer.new()
var connection_attempt_timer: float = 0
var connection_attempt_interval: float = 0.1  # 1 second
signal BodyReceived(receivedLandmarks: Array[Dictionary])
signal RulaRecieved(leftScore: int, rightScore: int)
signal OwasReceived(postureCode: Dictionary)

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
		text = ""
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			var message = packet_to_string(packet)
			#print("Received message: ", message)
			var parsedArray: Array = Parser(message)
			var tag: String = parsedArray[0]
			var dictArray: Array[Dictionary] = parsedArray[1]
			if (dictArray.size() != 0):
				if(tag == "Body" && dictArray.size() == 33):
					BodyReceived.emit(dictArray)
				elif(tag == "RULA"):
					RulaRecieved.emit(dictArray[0]["left"], dictArray[0]["right"])
				elif(tag == "OWAS"):
					OwasReceived.emit(dictArray[0])

func packet_to_string(packet: PackedByteArray) -> String:
	var message: String = ""
	for i in range(packet.size()):
		message += char(packet[i])
	return message

func Parser(message: String) -> Array:
	var msgArray: PackedStringArray = message.split("|");
	var dictArray: Array[Dictionary]
	if (msgArray.size() > 1):
		for i: int in range(1, msgArray.size()):
			var tempArr: PackedStringArray = msgArray[i].split("\n")
			var tempDict: Dictionary
			for j in tempArr.size() if (msgArray[0] != "Body") else 4:
				var item: String = tempArr[j]
				var tuple: PackedStringArray = item.split(": ")
				tempDict[tuple[0]] = float(tuple[1])
			dictArray.append(tempDict)
	var returnArray: Array = [msgArray[0], dictArray]
	return returnArray
	
