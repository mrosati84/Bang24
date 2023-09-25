extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
@export var maxPlayers = 8
@export var Logger : RichTextLabel

var isServer = false
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
		hostGame()
		
	$PlayerName.text = generate_random_nickname();
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# this get called on the server and clients
func peer_connected(id):
	Logger.append_log("Player Connected: " + str(id))
	print("Player Connected: " + str(id))

# this get called on the server and clients
func peer_disconnected(id):
	MultiplayerManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	
	for p in players:
		if p.name == str(id):
			p.queue_free()
			
	Logger.append_log("Player Disconnected: " + str(id))
	print("Player Disconnected: " + str(id))

# called only from clients
func connected_to_server():
	Logger.append_log("[CLIENT] Successfully connected to the server!")
	print("[CLIENT] Successfully connected to the server!")
	SendPlayerInformation.rpc_id(1, $PlayerName.text, multiplayer.get_unique_id())

# called only from clients
func connection_failed():
	Logger.append_log("[CLIENT] Unable to connect to the server.")
	print("[CLIENT] Unable to connect to the server.")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !MultiplayerManager.Players.has(id):
		MultiplayerManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in MultiplayerManager.Players:
			SendPlayerInformation.rpc(MultiplayerManager.Players[i].name, i)
	
func hostGame():
	isServer = true;
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, maxPlayers)
	if error != OK:
		Logger.append_log("[SERVER] ERROR: unable to host: " + error)
		print("[SERVER] ERROR: unable to host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	Logger.append_log("[SERVER] Waiting For Players...")
	print("[SERVER] Waiting For Players...")
	
func _on_host_button_down():
	hostGame()
# @FIXME server not having a player attached
#	SendPlayerInformation($PlayerName.text, multiplayer.get_unique_id())
	pass # Replace with function body.

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	pass # Replace with function body.

func _on_start_game_button_down():
	if (MultiplayerManager.Players.size() >= 2):
		Logger.append_log("Starting game...")
		StartGame.rpc()
	else:
		Logger.append_log("[ERROR] At least 2 players are needed to start the game!")
		print("[ERROR] At least 2 players are needed to start the game!")
	pass # Replace with function body.

func _on_quit_game_button_down():
	Logger.append_log("Bye Bye!")
	get_tree().quit()
	pass # Replace with function body.
	
@rpc("any_peer","call_local")
func StartGame():
	if isServer == false:
		var scene = load("res://levels/main.tscn").instantiate()
		get_tree().root.add_child(scene)
		self.hide()
	else:
		Logger.append_log("Game started.")	
