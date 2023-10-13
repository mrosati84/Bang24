extends Control

@export var dedicated_server_port = 8910
@export var max_players = 8
@export var player_scene : PackedScene

@onready var is_server = "--server" in OS.get_cmdline_args()
@onready var player_name_handle = $PanelContainer/MarginContainer/VBoxContainer/PlayerName
@onready var server_ip_port_handle = $PanelContainer/MarginContainer/VBoxContainer/ServerIpPort

var music_bus = AudioServer.get_bus_index("Master")

func generate_random_nickname():
	var rng = RandomNumberGenerator.new()
	var adjectives = ["Brave", "Swift", "Clever", "Curious", "Silent", "Mighty"]
	var nouns = ["Wolf", "Tiger", "Eagle", "Lion", "Bear", "Cheetah"]
	
	var random_adjective = adjectives[randi() % adjectives.size()]
	var random_noun = nouns[randi() % nouns.size()]
	var my_random_number = str(int(rng.randf_range(0, 9999)))
	var nickname = random_adjective + random_noun + my_random_number
	
	return nickname

# Called when the node enters the scene tree for the first time.
func _ready():
	$Error.hide()
	
	if is_server:
		start_network(true)
	else:
		player_name_handle.text = generate_random_nickname();

func start_network(server: bool):
	var peer = ENetMultiplayerPeer.new()
		
	if server:
		multiplayer.peer_connected.connect(create_player)
		multiplayer.peer_disconnected.connect(destroy_player)
		
		peer.create_server(dedicated_server_port)
		print('[SERVER] Server started! Listening on port: '+ str(dedicated_server_port))
	else:
		var server_ip_port = server_ip_port_handle.text.strip_edges()
		var parts = server_ip_port.split(":")
		var server_address
		var server_port
		
		if parts.size() == 2:
			server_address = parts[0].strip_edges()
			server_port = parts[1].to_int()
			
			print('[CLIENT] Client joining server at '+ str(server_address) +':'+ str(server_port))
			peer.create_client(server_address, server_port)
		else:
			print("[CLIENT] ERROR: Invalid 'address:port' format!")
			#@TODO: show an error, don't let the user continue!			

	multiplayer.multiplayer_peer = peer

func create_player(id):
	print("Adding player to scene with id " + str(id))

	# Instantiate a new player for this client.
	var p = player_scene.instantiate()
	
	# Set the name, so players can figure out their local authority
	p.name = str(id)

	$"../Level/SpawnPath".add_child(p)

func destroy_player(id):
	# Delete this peer's node.
	$"../Level/SpawnPath".get_node(str(id)).queue_free()
	
func show_error(message):
	$Error.text = "[ERROR] "+ str(message)
	$Error.show()

func _on_join_pressed():
	if player_name_handle.text == "":
		show_error("You must choose a nickname before joining!")
		
		return
		
	if server_ip_port_handle.text == "":
		show_error("You must choose a server address:port before joining!")
		
		return
	
	start_network(false)
	
	# hide the splash screen and show the level, scene and HUD
	visible = false
	$"../Level".visible = true
	$"../Level/HUD".visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_texture_button_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	
	if AudioServer.is_bus_mute(music_bus):
		$TextureButton.texture_normal = preload("res://art/settings_music_button_off.png")
	else:
		$TextureButton.texture_normal = preload("res://art/settings_music_button_on.png")
