extends Node2D

var peer = ENetMultiplayerPeer.new()
var port : int = 8910

func _ready():
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.server_disconnected.connect(on_server_disconnected)

func _on_play_pressed():
	start_game.rpc()

func _on_host_pressed():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	send_player_information(multiplayer.get_unique_id(), "Server")

func _on_join_pressed():
	peer.create_client("127.0.0.1", port)
	multiplayer.multiplayer_peer = peer

func _on_quit_pressed():
	get_tree().quit()

func on_peer_connected(id):
	print("on_peer_connected - Player connected with ID: " + str(id))

func on_peer_disconnected(id):
	print("on_peer_disconnected - Player disconnected with ID: " + str(id))

func on_connected_to_server():
	# send our info to the server
	send_player_information.rpc_id(1, multiplayer.get_unique_id(), "Test name")
	print("on_connected_to_server - Connected to server")

func on_server_disconnected():
	print("on_server_disconnected - Server disconnected")

@rpc("any_peer", "call_local")
func start_game():
	get_tree().change_scene_to_file("res://levels/main.tscn")

# keep updated the list of players in the MultiplayerManager node
# MultiplayerManager is auto-loaded
@rpc("any_peer")
func send_player_information(id, player_name):
	if !MultiplayerManager.players.has(id):
		MultiplayerManager.players[id] = {
			"name": player_name,
			"id": id,
			"score": 0
		}

	if multiplayer.is_server():
		for player_id in MultiplayerManager.players:
			send_player_information.rpc(player_id, MultiplayerManager.players[player_id]["name"])
