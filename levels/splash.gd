extends Node2D

@export var address = "127.0.0.1"
@export var port = 8910
@export var max_players = 8

var is_server = false
var peer
var rng = RandomNumberGenerator.new()

var adjectives = ["Brave", "Swift", "Clever", "Curious", "Silent", "Mighty"]
var nouns = ["Wolf", "Tiger", "Eagle", "Lion", "Bear", "Cheetah"]

func generate_random_nickname():
	var random_adjective = adjectives[randi() % adjectives.size()]
	var random_noun = nouns[randi() % nouns.size()]
	var my_random_number = str(int(rng.randf_range(0, 9999)))

	var nickname = random_adjective + random_noun + my_random_number
	
	return nickname

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		print("Hosting a standalone server...")
		host_game()
		
	$PlayerName.text = generate_random_nickname();

# this get called on the server and clients
func peer_connected(id):
	print("Player Connected: " + str(id))

# this get called on the server and clients
func peer_disconnected(id):
	MultiplayerManager.players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	
	for p in players:
		if p.name == str(id):
			p.queue_free()
			
	print("Player Disconnected: " + str(id))

# called only from clients
func connected_to_server():
	print("[CLIENT] Successfully connected to the server!")
	SendPlayerInformation.rpc_id(1, $PlayerName.text, multiplayer.get_unique_id())

# called only from clients
func connection_failed():
	print("[CLIENT] Unable to connect to the server.")

@rpc("any_peer")
func SendPlayerInformation(player_name, id):
	if !MultiplayerManager.players.has(id):
		MultiplayerManager.players[id] = {
			"name": player_name,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in MultiplayerManager.players:
			SendPlayerInformation.rpc(MultiplayerManager.players[i].name, i)
	
func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_players)
	if error != OK:
		print("[SERVER] ERROR: unable to host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("[SERVER] Waiting For Players...")
	
func _on_host_pressed():
	host_game()

func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_play_pressed():
	if (MultiplayerManager.players.size() >= 1):
		start_game.rpc()
	else:
		print("[ERROR] At least 2 players are needed to start the game!")

func _on_quit_game_button_down():
	get_tree().quit()

@rpc("any_peer", "call_local")
func start_game():
	if !multiplayer.is_server():
		var scene = load("res://levels/main.tscn").instantiate()
		get_tree().root.add_child(scene)
		self.hide()
		$SplashCamera.enabled = false
