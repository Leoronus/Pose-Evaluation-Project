extends RichTextLabel

# The URL we will connect to
@export var websocket_url = "ws://localhost:9001"

var socket = WebSocketPeer.new()
var connection_attempt_timer: float = 0
var connection_attempt_interval: float = 1.0  # 1 second

func _ready():
	socket.connect_to_url(websocket_url)

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
			text = message

func packet_to_string(packet: PackedByteArray) -> String:
	var message: String = ""
	for i in range(packet.size()):
		message += char(packet[i])
	return message
