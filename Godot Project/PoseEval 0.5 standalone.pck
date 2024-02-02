GDPC                �                                                                         T   res://.godot/exported/133200997/export-1aa45e0d16adc9ab31b26581a36ea19c-landmark.scn�*      �      �����J��>��D     T   res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn   @B      {      �?�S&:s!/q�G    X   res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res   p7      �
      �"�]8�Rta��z�    ,   res://.godot/global_script_class_cache.cfg  [      <      �0@l�؞�6�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      �      �̛�*$q�*�́     `   res://.godot/imported/pause_FILL0_wght400_GRAD0_opsz24.svg-fc71910a328719dc3804954491080383.ctex        �       ����1h@�������    h   res://.godot/imported/play_arrow_FILL0_wght400_GRAD0_opsz24.svg-28a95cc5e24d635bf97c3a5209702357.ctex   p      �       h�FA��Uҋm�6�!       res://.godot/uid_cache.bin  `      �       �j]�|�R����\�	       res://Scripts/OWAS label.gd @      �      v ���Ȟ���Z�       res://Scripts/PlayPause.gd         �      a#*�_�<Ǆ[�{���    $   res://Scripts/PythonScriptHandler.gd       �      ZҮ��ff�K~ُ
�
       res://Scripts/RULA label.gd �      �      � ���X3�s7�k��    $   res://Scripts/WebsocketInteractor.gd�      X      t�+�#��sy��́:�    (   res://Scripts/visualizationManager.gd    
      m      }��1���=dg��)       res://icon.svg  P\      �      C��=U���^Qu��U3       res://icon.svg.import   �)      �       ݽ������5%��Z�    8   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg.import �       �       pJ�a�^�kc���v    <   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svg.importP      �       ��!��ƅ�m�I��       res://landmark.tscn.remap   �Y      e       ƌ/<m�BHQ�V�N���       res://mainTheme.tres.remap  0Z      f       �V*M�8�	�z��       res://project.binarya      M      rY��b��d���c�>       res://scene.tscn.remap  �Z      b       ��w$yWJMX��        GST2            ����                        L   RIFFD   WEBPVP8L7   /�0��?��"�G�
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
               extends RichTextLabel


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


func _process(delta):
	pass


func _on_tree_exiting():
	OS.kill(pid)
             extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_websocket_interactor_rula_received(leftScore, rightScore):
	text = "RULA left: " + str(leftScore) + "\nRULA right: " + str(rightScore)
       class_name visualizationManager extends Node3D


var landmarks: Array[Node3D] ## Array of indicator nodes.
var landmarkTargets: Array[Vector3] ## Array of targets, to which the nodes are bound kind of elastically.
@export var sphereSize: float = 0.1 ## Scaling factor for all indicator spheres, adjustable from inspector.
@export var snapFactor: float = 0.8
var doneLoading: bool = false


func _ready():
	landmarkTargets.resize(33)
	for i: int in 33: # create indicators for the 33 landmarks
		var sphere: MeshInstance3D = MeshInstance3D.new() # create node
		sphere.mesh = SphereMesh.new() # assign generic sphere mesh
		sphere.name = "landmark " + str(i)
		var angle_rad: float = deg_to_rad(10 * i)
		sphere.transform.origin = Vector3(cos(angle_rad), sin(angle_rad), 0.0) # randomize each node's position, doesn't serve any real purpose
		sphere.scale = Vector3(1,1,1) * sphereSize
		landmarks.append(sphere)
		add_child(sphere) # make new node a child of the visualization manager's node


func _process(delta):
	for i in 33: # update indicator sizes
		var sphere = landmarks[i]
		sphere.scale = Vector3(1,1,1) * sphereSize
		if doneLoading: sphere.transform.origin += (landmarkTargets[i] - landmarks[i].transform.origin) * snapFactor
	
	if(!doneLoading):
		rotation_degrees += Vector3(0, 0, -90 * delta)
	else:
		rotation_degrees = Vector3.ZERO


## Updates indicator positions. Must be connected to the bodyReceived signal.
func _on_websocket_interactor_body_received(receivedLandmarks: Array[Dictionary]):
	doneLoading = true
	for i in 33:
		var mark = receivedLandmarks[i]
		landmarkTargets[i] = Vector3(mark["x"], mark["y"], mark["z"])
   class_name WebsocketInteractor extends RichTextLabel

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
			var packet = _socket.get_packet()
			var message = packetToString(packet)
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
				tempDict[tuple[0]] = float(tuple[1])
			dictArray.append(tempDict)
	var returnArray: Array = [msgArray[0], dictArray]
	return returnArray
	


func _on_play_pause_button_up():
	play = !play


func _on_button_button_up():
	_socket.send_text("whoop")
        GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
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
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere 	   _bundled        !   local://StandardMaterial3D_2bvdn          local://SphereMesh_fgh62 &         local://PackedScene_p1ema Q         StandardMaterial3D    n         SphereMesh    p             n         PackedScene    z      	         names "         Node3D    MeshInstance3D    mesh    	   variants                      node_count             nodes        ��������        ����                      ����                    conn_count              conns               node_paths              editable_instances              version       n      RSRC         RSRC                    Theme            ��������                                            *      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    Button/styles/disabled    Button/styles/hover    Button/styles/normal    Button/styles/pressed    Label/colors/font_color    Label/styles/normal    Panel/styles/panel    PanelContainer/styles/panel #   RichTextLabel/colors/default_color           local://StyleBoxFlat_4od4t R         local://StyleBoxFlat_gmne7 �         local://StyleBoxFlat_cg1h3 �         local://StyleBoxFlat_pgwmw Y         local://StyleBoxFlat_lutax �         local://StyleBoxFlat_cityb ;         local://StyleBoxFlat_wyh1d 	         local://Theme_m0x1i �	         StyleBoxFlat          |�?��^?��M?  �?	         
                                 ��?��?��?  �?      d         d         d         d            StyleBoxFlat          ��?  �?��k?  �?	         
                                               �?      d         d         d         d            StyleBoxFlat                �?PUU?  �?	         
                                               �?      d         d         d         d            StyleBoxFlat              ��?   ?  �?         StyleBoxFlat              ��Y?PU5?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?                                             StyleBoxFlat            �@        �@        �@        �@        �?  �?  �?  �?	         
                                               �?      
         
         
         
            Theme            �?          !             "            #            $            %                    �?&            '            (            )                    �?      RSRC         RSRC                    PackedScene            ��������                                            #      resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script    default_base_scale    default_font    default_font_size    PanelContainer/styles/panel 	   _bundled 	      Script &   res://Scripts/visualizationManager.gd ��������   Theme    res://mainTheme.tres 
[	��Շ\   Script %   res://Scripts/WebsocketInteractor.gd ��������   Script %   res://Scripts/PythonScriptHandler.gd ��������   Script    res://Scripts/RULA label.gd ��������   Script    res://Scripts/OWAS label.gd ��������
   Texture2D 1   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg @l@��N�S   Script    res://Scripts/PlayPause.gd ��������
   Texture2D 6   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svg �]��_�2      local://StyleBoxFlat_g3f6r �         local://Theme_h8gba �         local://PackedScene_e2j1m �         StyleBoxFlat            �?  �?  �?  �?	         
                                               �?                                             Theme    !                      PackedScene    "      	         names "   J      Node3D    visualizationManager    script    snapFactor    Control    layout_mode    anchors_preset    offset_right    offset_bottom    theme    CanvasLayer    WebsocketInteractor    z_index    anchor_left    anchor_top    anchor_right    anchor_bottom    offset_left    offset_top $   theme_override_colors/default_color +   theme_override_font_sizes/normal_font_size    text    RichTextLabel    PythonScriptHandler    grow_horizontal    grow_vertical    startBackend    background    color 
   ColorRect    Panel    VBoxContainer    clip_contents    custom_minimum_size    PanelContainer    size_flags_vertical    Label    horizontal_alignment    vertical_alignment 
   RULA text    PanelContainer2 
   OWAS text    BoxContainer 
   alignment    clip_children    size_flags_horizontal    SubViewportContainer    SubViewport    handle_input_locally    size    render_target_update_mode 	   Camera3D 
   transform    current    fov 
   PlayPause    icon    icon_alignment    expand_icon    icons    Button    scale '   _on_websocket_interactor_body_received    BodyReceived '   _on_websocket_interactor_owas_received    OwasReceived '   _on_websocket_interactor_rula_received    RulaReceived    _on_tree_exiting    tree_exiting    _on_play_pause_button_up 
   button_up    _on_button_up    _on_button_button_up    	   variants    B             )   �������?                   B                  ����   9��>   R��>   ���   �z,B   ?5�C   �sC                 �?            test                      ?     ��     ��     �C     	C           �?          �?   (                             �?   ��!?  �?��o?  �?   T�E?   ?5~?   �(|?   �� ?     A   ���=   �_��
      A   A      A      �      RULA                OWAS              ���                      -   ^  K       �?            ��?��$=    ��$���?    �/b>��X@   oC?   �zt?   �K[�   )\_�   �t�   �u�                                               qD    �D     sD    �D
   &�@&�@      node_count             nodes     �  ��������        ����                       ����                                  ����                           	                 
   
   ����                     ����                        	            	      
                                                              ����                                                                                                              ����                                                        ����	                   !      "      #      $      %      &   	                       ����          !   '                              (      (      )      )               	                 "   "   ����         #      	          	             ����             
       $   $   ����         	         *   %      &          
          '   ����         #         +              "   (   ����         #      	                       ����                    $   $   ����         	         ,   %      &                    )   ����         #         -              *   *   ����                        .               +                 "   "   ����   ,                   -   /   #   /   	   0              .   .   ����                -   /   #   /   	                 /   /   ����   0   1   1   2   2   /              3   3   ����   4   3   5      6                 <   7   ����            4      5      4      5      6      7      8      9   	      8   :   9      :         ;   ;   <              <   <   ����      =      >      ?      @   =   A             conn_count             conns     8         ?   >                    ?   >                    A   @                    C   B                    E   D                    G   F                    G   H                    G   I                    node_paths              editable_instances              version             RSRC     [remap]

path="res://.godot/exported/133200997/export-1aa45e0d16adc9ab31b26581a36ea19c-landmark.scn"
           [remap]

path="res://.godot/exported/133200997/export-da6b9c1583b5806196f3f68541415ed6-mainTheme.res"
          [remap]

path="res://.godot/exported/133200997/export-78c237d4bfdb4e1d02e0b5f38ddfd8bd-scene.scn"
              list=Array[Dictionary]([{
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
             @l@��N�S0   res://icons/pause_FILL0_wght400_GRAD0_opsz24.svg�]��_�25   res://icons/play_arrow_FILL0_wght400_GRAD0_opsz24.svgڒϿU    res://icon.svg�������<   res://landmark.tscn
[	��Շ\   res://mainTheme.treskgb;�rba   res://scene.tscn          ECFG      application/config/name         PoseEval   application/run/main_scene         res://scene.tscn   application/config/features   "         4.2    Mobile  "   application/run/low_processor_mode            application/config/icon         res://icon.svg     dotnet/project/assembly_name         PoseEval   