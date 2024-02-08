GDPC                �
                                                                         T   res://.godot/exported/133200997/export-1aa45e0d16adc9ab31b26581a36ea19c-landmark.scnpE      �      \RDģ�p����[K|&P    T   res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn    ]      �      C'�"��@G�/1�    X   res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res   PR      �
      �%DH�#i�-:���)    ,   res://.godot/global_script_class_cache.cfg  y      l      +u��'\b���
Y�]�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�7      �      �̛�*$q�*�́     `   res://.godot/imported/pause_FILL0_wght400_GRAD0_opsz24.svg-fc71910a328719dc3804954491080383.ctex�
      �       ����1h@�������    h   res://.godot/imported/play_arrow_FILL0_wght400_GRAD0_opsz24.svg-28a95cc5e24d635bf97c3a5209702357.ctex          �       h�FA��Uҋm�6�!    d   res://.godot/imported/record_FILL0_wght400_GRAD0_opsz24.svg-b17e58e6fa0664225014ea43a2494e4a.ctex   �      �       uQ�%V	�E��s���    `   res://.godot/imported/stop_FILL0_wght400_GRAD0_opsz24.svg-194dacf69ff1adff13174587394713f9.ctex �      �       jw��Ĩ����v��V�G       res://.godot/uid_cache.bin  @�      n      K���aA~�Sg�m�O��       res://Scripts/Data panel.gd @            ]��D����c昿u       res://Scripts/OWAS label.gd P      �      v ���Ȟ���Z�       res://Scripts/PlayPause.gd  0      �      a#*�_�<Ǆ[�{���    $   res://Scripts/PythonScriptHandler.gd      �      ͣ.��@G;d����       res://Scripts/RULA label.gd �      �      � ���X3�s7�k��        res://Scripts/RecordingButton.gd�            Zv��z�xVۊ�d"v�m    $   res://Scripts/WebsocketInteractor.gd�*            ݻ� �R����ic�VD�    (   res://Scripts/visualizationManager.gd   P      d      ���+w�F�<o�{-
e	    (   res://addons/Asset_Drawer/FileSystem.gd         �
      ͙�D���6�bD��X>       res://icon.svg  ��      �      C��=U���^Qu��U3       res://icon.svg.import   �D      �       ݽ������5%��Z�    8   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg.import @      �       pJ�a�^�kc���v    <   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svg.import       �       ��!��ƅ�m�I��    8   res://icons/record_FILL0_wght400_GRAD0_opsz24.svg.import�      �       eh�H��L�cƸ�h    8   res://icons/stop_FILL0_wght400_GRAD0_opsz24.svg.import  `      �       �*E"���j`t�r,       res://landmark.tscn.remap   �w      e       ƌ/<m�BHQ�V�N���       res://mainTheme.tres.remap  0x      f       �V*M�8�	�z��       res://project.binary��      �      ����� %���t�h��Z       res://scene.tscn.remap  �x      b       ��w$yWJMX��        @tool
extends EditorPlugin

# Padding from the bottom when popped out
var padding: int = 20

# The file system
var FileDock: Object

# Toggle for when the file system is moved to bottom
var filesBottom: bool = false

var newSize: Vector2
var initialLoad: bool = false

var AssetDrawerShortcut: InputEventKey = InputEventKey.new()
var showing: bool = false

func _enter_tree() -> void:
	# Add tool button to move shelf to editor bottom
	add_tool_menu_item("Files to Bottom", Callable(self, "FilesToBottom"))
	
	# Get our file system
	FileDock = self.get_editor_interface().get_file_system_dock()
	await get_tree().create_timer(0.1).timeout
	FilesToBottom()

#region show hide filesystem
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_SPACE) &&
		Input.is_key_pressed(KEY_CTRL)):
			if filesBottom == true:
				match showing:
					false:
						make_bottom_panel_item_visible(FileDock)
						showing = true
					true:
						print("hide")
						hide_bottom_panel()
						showing = false
#endregion

func _exit_tree() -> void:
	remove_tool_menu_item("Files to Bottom")
	FilesToBottom()


func _process(delta: float) -> void:
	
	newSize = FileDock.get_window().size
	
	# Keeps the file system from being unusable in size
	if FileDock.get_window().name == "root" && filesBottom == false:
		FileDock.get_child(3).get_child(0).size.y = newSize.y - padding
		FileDock.get_child(3).get_child(1).size.y = newSize.y - padding
		return
		
	# Adjust the size of the file system based on how far up
	# the drawer has been pulled
	if FileDock.get_window().name == "root" && filesBottom == true:
		newSize = FileDock.get_parent().size
		FileDock.get_child(3).get_child(0).size.y = newSize.y - 60
		FileDock.get_child(3).get_child(1).size.y = newSize.y - 60
		return
	
	# Keeps our systems sized when popped out
	if (FileDock.get_window().name != "root" && filesBottom == false):
		FileDock.get_window().min_size.y = 50
		FileDock.get_child(3).get_child(0).size.y = newSize.y - padding
		FileDock.get_child(3).get_child(1).size.y = newSize.y - padding
		
		# Centers window on first pop
		if initialLoad == false:
			initialLoad = true
			var screenSize: Vector2 = DisplayServer.screen_get_size()
			FileDock.get_window().position = screenSize/2
			
		return

# Moves the files between the bottom panel and the original dock
func FilesToBottom() -> void:
	if filesBottom == true:
		remove_control_from_bottom_panel(FileDock)
		add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, FileDock)
		filesBottom = false
		return

	FileDock = self.get_editor_interface().get_file_system_dock()
	remove_control_from_docks(FileDock)
	add_control_to_bottom_panel(FileDock, "File System")
	filesBottom = true

       GST2            ����                        L   RIFFD   WEBPVP8L7   /�0��?��"�G�
ڶ����2+��3�����O@@?�3I�'�g Gj             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cseelwgtytwsm"
path="res://.godot/imported/pause_FILL0_wght400_GRAD0_opsz24.svg-fc71910a328719dc3804954491080383.ctex"
metadata={
"vram_texture": false
}
    GST2            ����                        �   RIFF�   WEBPVP8L�   /�����$��I�sw��C�ֶ�y�0�h�8 ����-�D���mL��*r52��Dq�U��:���r�bC/%q�h�[��z�i	�с_ ��͘0�>�*O�7Y uA4�Ǧ>�@o
����T�����*:�<��Y��  [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bsahprpsxdsul"
path="res://.godot/imported/play_arrow_FILL0_wght400_GRAD0_opsz24.svg-28a95cc5e24d635bf97c3a5209702357.ctex"
metadata={
"vram_texture": false
}
               GST2            ����                        �   RIFF�   WEBPVP8L�   /������'���3�pI�bU�XRt��=9̞X�|=��h'0�X,0\=�Z�o��(�X4l�<�'�&�(�:�e �q$W� O!�C�%I�ꓼ�%.H;ē�� i�O��y3�ď\*���G�B*�"}���#�`��Pe�8W�V#sa�j/���;��{��     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b7ui2jsnepthn"
path="res://.godot/imported/record_FILL0_wght400_GRAD0_opsz24.svg-b17e58e6fa0664225014ea43a2494e4a.ctex"
metadata={
"vram_texture": false
}
   GST2            ����                        J   RIFFB   WEBPVP8L5   /�0��?��"�G��IR������	E������"�6�7��+k               [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://duki2jgu2qlg"
path="res://.godot/imported/stop_FILL0_wght400_GRAD0_opsz24.svg-194dacf69ff1adff13174587394713f9.ctex"
metadata={
"vram_texture": false
}
      extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer3.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_analysis_received(results):
	$PanelContainer3.show()
	$"../../RecordingButton".disabled = false
	#$PanelContainer2.hide()
	#$PanelContainer.hide()
	$"PanelContainer3/VBoxContainer/Analysis text".text = \
			"Back position: " + results["back_Position"] + \
			"\nBack action: " + results["back_Action"] + \
			"\n\nArms position: " + results["arms_Position"] + \
			"\nArms action: " + results["arms_Action"] + \
			"\n\nLegs position: " + results["legs_Position"] + \
			"\nLegs action: " + results["legs_Action"]
  extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_owas_received(postureCode):
	var pc: Dictionary = postureCode
	text = "back: " + str(pc["back"]) + "\narms: " + str(pc["arms"]) + "\nlegs: " + str(pc["legs"]) + "\nweight: " + str(pc["weight"])
       extends Button

@export var icons: Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.disabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_body_received(_receivedLandmarks):
	disabled = false


var currentIcon: int = 0
func _on_button_up():
	currentIcon = (currentIcon + 1) % 2;
	icon = icons[currentIcon]
            extends RichTextLabel

var pid: int = 0	## ProcessID for the backend
@export var startBackend: bool = false
@export var showTerminal: bool = true


func _ready():
	if(startBackend):
		pid = OS.create_process("python",["../main.py"], showTerminal)
		print(pid)
		if (pid == -1):
			text = "Failed to launch backend."


func _process(_delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
            extends Button

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
     extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_rula_received(leftScore, rightScore):
	text = "RULA left: " + str(leftScore) + "\nRULA right: " + str(rightScore)
       class_name visualizationManager extends Node3D
## Manages the 3D visualization of received landmarks.


var landmarks: Array[Node3D] ## Array of indicator nodes.
var landmarkTargets: Array[Vector3] ## Array of targets, to which the nodes are bound kind of elastically.
@export var sphereSize: float = 0.1 ## Scaling factor for all indicator spheres, adjustable from inspector.
@export var snapFactor: float = 0.1 ## controls the visualization's smoothing. At 1 the indicators immediately snap to their updated positions.
var _doneLoading: bool = false
## Array containing the indexes for each bone's landmarks.
var boneArray: Array[Array] = [\
		[0,2],[0,5],[2,7],\
		[5,8],[9,10],[11,12],\
		[11,13],[11,23],[12,14],\
		[12,24],[13,15],[14,16],\
		[15,17],[15,19],[15,21],\
		[16,18],[16,20],[16,22],\
		[17,19],[18,20],[23,24],\
		[23,25],[24,26],[25,27],\
		[26,28],[27,29],[27,31],\
		[28,30],[28,32],[29,31],\
		[30,32]\
		]
var _bones: Array[MeshInstance3D] = []


func _ready():
	landmarkTargets.resize(33)
	for i: int in 33: # create indicators for the 33 landmarks
		var sphere: MeshInstance3D = MeshInstance3D.new() # create node
		sphere.mesh = SphereMesh.new() # assign generic sphere mesh
		sphere.name = "landmark " + str(i)
		var angle_rad: float = deg_to_rad(10 * i)
		sphere.transform.origin = Vector3(cos(angle_rad), sin(angle_rad), 0.0)
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere) # make new node a child of the visualization manager's node


func _process(delta):
	for i in 33: # update indicator sizes
		var sphere = landmarks[i]
		sphere.scale = Vector3(1,1,1) * sphereSize
		var moveVec := (landmarkTargets[i] - landmarks[i].transform.origin) * snapFactor
		if (_doneLoading && moveVec.length() > 0.01): sphere.transform.origin += moveVec
	
	if(!_doneLoading):
		rotation_degrees += Vector3(0, 0, -90 * delta) #loading animation
	else:
		#var timespan: float = Time.get_unix_time_from_system()
		$"../Control/CanvasLayer/RecordingButton".init = true #enable recording
		rotation_degrees = Vector3.ZERO
		for bone in _bones: #delete old bones
			bone.queue_free()
		_bones.clear()
		for bonePair in boneArray: # draw new bones
			_bones.append(_line(landmarks[bonePair[0]].global_position, landmarks[bonePair[1]].transform.origin))
		
		#timespan = Time.get_unix_time_from_system() - timespan
		#print(timespan)


func _line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(mesh_instance)
	return mesh_instance


## Updates indicator positions. Must be connected to the bodyReceived signal.
func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	_doneLoading = true
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarkTargets[i] = Vector3(float(mark["x"]), float(mark["y"]), float(mark["z"]))
		landmarks[i].transparency = 1 - float(mark["visibility"])
            class_name WebsocketInteractor extends RichTextLabel

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
              GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://udjh7bjnck"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
   RSRC                    PackedScene            ��������                                            {      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere 	   _bundled        !   local://StandardMaterial3D_2bvdn          local://SphereMesh_fgh62 &         local://PackedScene_elbt5 Q         StandardMaterial3D    n         SphereMesh    p             n         PackedScene    z      	         names "         Node3D    MeshInstance3D    mesh    	   variants                      node_count             nodes        ��������        ����                      ����                    conn_count              conns               node_paths              editable_instances              version       n      RSRC         RSRC                    Theme            ��������                                            *      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Button/styles/disabled    Button/styles/hover    Button/styles/normal    Button/styles/pressed    Label/colors/font_color    Label/styles/normal    Panel/styles/panel    PanelContainer/styles/panel #   RichTextLabel/colors/default_color           local://StyleBoxFlat_4od4t R         local://StyleBoxFlat_gmne7 �         local://StyleBoxFlat_cg1h3 �         local://StyleBoxFlat_pgwmw Y         local://StyleBoxFlat_lutax �         local://StyleBoxFlat_cityb ;         local://StyleBoxFlat_wyh1d 	         local://Theme_proj7 �	         StyleBoxFlat          |�?��^?��M?  �?	         
                                 ��?��?��?  �?      d         d         d         d            StyleBoxFlat          ��?  �?��k?  �?	         
                                               �?      d         d         d         d            StyleBoxFlat                �?PUU?  �?	         
                                               �?      d         d         d         d            StyleBoxFlat              ��?   ?  �?         StyleBoxFlat              ��Y?PU5?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?      
         
         
         
            Theme            �?          !             "            #            $            %                    �?&            '            (            )                    �?      RSRC         RSRC                    PackedScene            ��������                                            #      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    PanelContainer/styles/panel 	   _bundled       Script &   res://Scripts/visualizationManager.gd ��������   Theme    res://mainTheme.tres 
[	��Շ\   Script    res://Scripts/Data panel.gd ��������   Script    res://Scripts/RULA label.gd ��������   Script    res://Scripts/OWAS label.gd ��������
   Texture2D 1   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg @l@��N�S   Script    res://Scripts/PlayPause.gd ��������
   Texture2D 6   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svg �]��_�2
   Texture2D 2   res://icons/record_FILL0_wght400_GRAD0_opsz24.svg �e��f�@   Script !   res://Scripts/RecordingButton.gd ��������
   Texture2D 0   res://icons/stop_FILL0_wght400_GRAD0_opsz24.svg �\~�x��   Script %   res://Scripts/WebsocketInteractor.gd ��������   Script %   res://Scripts/PythonScriptHandler.gd ��������      local://StyleBoxFlat_g3f6r �         local://Theme_h8gba �         local://PackedScene_rv7fv �         StyleBoxFlat            �?  �?  �?  �?	         
                                               �?                                             Theme    !                      PackedScene    "      	         names "   O      Node3D    visualizationManager    script    sphereSize    Control    layout_mode    anchors_preset    offset_right    offset_bottom    theme    CanvasLayer    background    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    color 
   ColorRect    Panel    anchor_left    offset_left    offset_top    Data panel    clip_contents    custom_minimum_size    VBoxContainer    PanelContainer    size_flags_vertical    Label    text    horizontal_alignment    vertical_alignment 
   RULA text    RichTextLabel    PanelContainer2 
   OWAS text    PanelContainer3    Analysis text    BoxContainer    size_flags_horizontal 
   alignment    clip_children    SubViewportContainer    SubViewport    handle_input_locally    size    size_2d_override_stretch    render_target_update_mode 	   Camera3D 
   transform    current    fov 
   PlayPause    anchor_top    icon    icon_alignment    expand_icon    icons    Button    RecordingButton    WebsocketInteractor $   theme_override_colors/default_color +   theme_override_font_sizes/normal_font_size    PythonScriptHandler    startBackend    _on_button_up 
   button_up    _on_play_pause_button_up    _on_recording_button_button_up +   _on_websocket_interactor_analysis_received    AnalysisReceived '   _on_websocket_interactor_body_received    BodyReceived '   _on_websocket_interactor_owas_received    OwasReceived '   _on_websocket_interactor_rula_received    RulaReceived    _on_tree_exiting    tree_exiting    	   variants    D             )   333333�?                   B                    �?         ��!?  �?��o?  �?   ����   T�E?   ?5~?   �(|?   �� ?     A   ���=   �_��      
      A   A            A      �               RULA                OWAS                Analyse                       -   h  U       �?            ��?��$=    ��$���?    �/b>��X@   oC?   �zt?   �K[�   )\_�   �t�   �u�                                             ���   �t�   )\k�               	                        
      9��>   R��>   ���   �z,B   ?5�C   �sC                 �?            test                      ?     ��     ��     �C     	C     �?          �?   (                  node_count             nodes     �  ��������        ����                       ����                                  ����                           	                 
   
   ����                     ����                                    	                    ����	      
                                             	                       ����                        
                                                   	                             ����               	                       ����                          ����         	                                   !       ����                                   "   ����               	                       ����                          ����         	                                   !   #   ����                                   $   ����                                ����                          ����                                      !   %   ����                          &   &   ����	      
                                 '            (                       ����   )                  '            	                 *   *   ����               	                 +   +   ����   ,      -       .      /                 0   0   ����   1   !   2      3                 :   4   ����      
      "   5   #      "      #      $      %      &      '   	      6   (   7      8         )   9   *              :   ;   ����      
      "   5   #      "      #      $      +      ,      -   	      6   .   7      8         /   9   0              !   <   ����      
      1   5   2      1      2      3      4      5      6   =   7   >   8      9      :              !   ?   ����      ;      <   5   <      <      <      =      >      ?      @               =   A   >   B      C   @                conn_count    
         conns     F         B   A                    B   C                    B   A                    B   D                    F   E                    H   G                    H   G                    J   I                 
   L   K                    N   M                    node_paths              editable_instances              version             RSRC      [remap]

path="res://.godot/exported/133200997/export-1aa45e0d16adc9ab31b26581a36ea19c-landmark.scn"
           [remap]

path="res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res"
          [remap]

path="res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn"
              list=Array[Dictionary]([{
"base": &"Button",
"class": &"MaterialButton",
"icon": "res://addons/material-design-icons/nodes/MaterialButton.svg",
"language": &"GDScript",
"path": "res://addons/material-design-icons/nodes/MaterialButton.gd"
}, {
"base": &"Label",
"class": &"MaterialIcon",
"icon": "res://addons/material-design-icons/nodes/MaterialIcon.svg",
"language": &"GDScript",
"path": "res://addons/material-design-icons/nodes/MaterialIcon.gd"
}, {
"base": &"AnimatedSprite2D",
"class": &"SVGAnimatedSprite2D",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGAnimatedSprite2D.gd"
}, {
"base": &"Camera2D",
"class": &"SVGCamera2D",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGCamera2D.gd"
}, {
"base": &"Sprite2D",
"class": &"SVGSprite2D",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGSprite2D.gd"
}, {
"base": &"Resource",
"class": &"SVGTexture2D",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGTexture2D.gd"
}, {
"base": &"EditorImportPlugin",
"class": &"SVGTexture2DEditorImportPlugin",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGTexture2DEditorImportPlugin.gd"
}, {
"base": &"ResourceFormatLoader",
"class": &"SVGTexture2DFormatLoader",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGTexture2DLoader.gd"
}, {
"base": &"ResourceFormatSaver",
"class": &"SVGTexture2DFormatSaver",
"icon": "",
"language": &"GDScript",
"path": "res://addons/merovi.svgtexture2d/SVGTexture2DSaver.gd"
}, {
"base": &"RichTextLabel",
"class": &"WebsocketInteractor",
"icon": "",
"language": &"GDScript",
"path": "res://Scripts/WebsocketInteractor.gd"
}, {
"base": &"Node3D",
"class": &"visualizationManager",
"icon": "",
"language": &"GDScript",
"path": "res://Scripts/visualizationManager.gd"
}])
    <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             @l@��N�S0   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg�]��_�25   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svg�e��f�@1   res://icons/record_FILL0_wght400_GRAD0_opsz24.svg�\~�x��/   res://icons/stop_FILL0_wght400_GRAD0_opsz24.svgڒϿU    res://icon.svg�������<   res://landmark.tscn
[	��Շ\   res://mainTheme.treskgb;�rba   res://scene.tscn  ECFG      application/config/name         PoseEval   application/run/main_scene         res://scene.tscn   application/config/features   "         4.2    Mobile  "   application/run/low_processor_mode            application/config/icon         res://icon.svg     dotnet/project/assembly_name         PoseEval   editor_plugins/enabled4   "      %   res://addons/Asset_Drawer/plugin.cfg     