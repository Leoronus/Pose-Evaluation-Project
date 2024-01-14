GDPC                                                                                         T   res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn   �%      �      M<��9;�k�E�Gb�    X   res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res   �      I      �eRKb�+	%ݗ+K!�r    ,   res://.godot/global_script_class_cache.cfg  �5             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �9      u       >M�OĆh�����9U9       res://Scripts/OWAS label.gd         �      X���_� !��F    $   res://Scripts/PythonScriptHandler.gd�      �      |Z������mM/G,��       res://Scripts/RULA label.gd �      �      H��~��Oz�%��OKV    $   res://Scripts/WebsocketInteractor.gd�      G      g�%�ҡ���՘\�~�    (   res://Scripts/visualizationManager.gd   `      *      $�����"��f�w?05!       res://icon.svg  �5      �      C��=U���^Qu��U3       res://icon.svg.import   �      �       ݽ������5%��Z�       res://mainTheme.tres.remap  �4      f       �V*M�8�	�z��       res://project.binary:      V      ka�,\�[��p�'�       res://scene.tscn.remap  @5      b       ��w$yWJMX��        extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_websocket_interactor_owas_received(postureCode):
	var pc: Dictionary = postureCode
	text = "back: " + str(pc["back"]) + "\narms: " + str(pc["arms"]) + "\nlegs" + str(pc["legs"]) + "\nweight: " + str(pc["weight"])
          extends RichTextLabel

var pid: int
@export var showTerminal: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pid = OS.create_process("python",["C:/Users/Leon Wigro/Documents/GitHub/Pose-Evaluation-Project/main.dont"], showTerminal)
	print(pid)
	if (pid == -1):
		text = "Failed to launch backend."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
     extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_websocket_interactor_rula_recieved(leftScore, rightScore):
	text = "RULA left: " + str(leftScore) + "\nRULA right: " + str(rightScore)
        extends Node3D


var landmarks: Array[Node3D]
@export var a: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	for i: int in 33:
		var sphere = MeshInstance3D.new()
		sphere.mesh = SphereMesh.new()
		sphere.name = "landmark " + str(i)
		sphere.transform.origin = Vector3(rng.randf_range(-10, 10), rng.randf_range(-10, 10), 0.0)
		sphere.scale = Vector3(1, 1, 1) * 0.15
		landmarks.append(sphere)
		add_child(sphere)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarks[i].transform.origin = Vector3(mark["x"], - mark["y"], mark["z"])
      extends RichTextLabel

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
	
         GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
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
   RSRC                    Theme            ��������                                            &      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Label/colors/font_color    Label/styles/normal    Panel/styles/panel    PanelContainer/styles/panel #   RichTextLabel/colors/default_color           local://StyleBoxFlat_lutax P         local://StyleBoxFlat_cityb �         local://StyleBoxFlat_wyh1d �         local://Theme_codm5 �         StyleBoxFlat              ��Y?PU5?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?      
         
         
         
            Theme            �?          !                    �?"             #            $            %                    �?      RSRC       RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script &   res://Scripts/visualizationManager.gd ��������   Theme    res://mainTheme.tres 
[	��Շ\   Script %   res://Scripts/WebsocketInteractor.gd ��������   Script %   res://Scripts/PythonScriptHandler.gd ��������   Script    res://Scripts/RULA label.gd ��������   Script    res://Scripts/OWAS label.gd ��������      local://PackedScene_1mar4 &         PackedScene          	         names "   9      Node3D    visualizationManager    script    Control    layout_mode    anchors_preset    offset_right    offset_bottom    theme    CanvasLayer    WebsocketInteractor    z_index    offset_left    offset_top    RichTextLabel    PythonScriptHandler    anchor_left    anchor_top    anchor_right    anchor_bottom    grow_horizontal    grow_vertical $   theme_override_colors/default_color +   theme_override_font_sizes/normal_font_size    background    color 
   ColorRect    SubViewportContainer    SubViewport    handle_input_locally    size    render_target_update_mode 	   Camera3D 
   transform    current    fov    Panel    VBoxContainer    clip_contents    custom_minimum_size    PanelContainer    size_flags_vertical    Label    text    horizontal_alignment    vertical_alignment 
   RULA text    PanelContainer2 
   OWAS text '   _on_websocket_interactor_body_received    BodyReceived '   _on_websocket_interactor_owas_received    OwasReceived '   _on_websocket_interactor_rula_recieved    RulaRecieved    _on_tree_exiting    tree_exiting    	   variants    0                                B                    \B     B     �C     �C                     ?     ��     ��     �C     	C           �?          �?   (                       �?      ?  �?��j?  �?     �A     �A     \�     ��       -   ^  K             �?            ��?��$=    ��$���?    �/b>��X@         ����   T�E?   ?5~?   �(|?   �� ?     A   ���=   �_��
      A   A      A      �      RULA                OWAS                node_count             nodes     H  ��������        ����                       ����                            ����                                            	   	   ����                  
   ����                              	      
                    ����                                                                                                        ����                                                        ����
                                                                                ����                                        ����   !      "       #                 $   $   ����	      !      "      #      $      %      &      '      (             
       %   %   ����   &       '   )            !                  *      *      +      +                                (   (   ����         )                       %   %   ����                    *   *   ����               +   ,   ,      -                    .   ����         )         -              (   /   ����         )                       %   %   ����                    *   *   ����               +   .   ,      -                    0   ����         )         /             conn_count             conns              2   1                    4   3                    6   5                    8   7                    node_paths              editable_instances              version             RSRC     [remap]

path="res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res"
          [remap]

path="res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn"
              list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             ڒϿU    res://icon.svg
[	��Շ\   res://mainTheme.treskgb;�rba   res://scene.tscn����h   res://temp.tscn           ECFG      application/config/name         PoseEval   application/run/main_scene         res://scene.tscn   application/config/features   "         4.2    Mobile     application/config/icon         res://icon.svg     dotnet/project/assembly_name         PoseEval#   rendering/renderer/rendering_method         mobile            