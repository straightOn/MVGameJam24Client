extends RpcBase

class_name ConnectionHandler

signal object_position_update_event(id: int, position: Vector2)
signal object_created_event(id: int, type: String, initial_position: Vector2)
signal object_removed_event(id: int)

var connected: bool = false
	
func connect_to_server(target: String):
	print_debug("connecting to server: ", target)
	if (!connected):
		var peer = ENetMultiplayerPeer.new()
		peer.create_client(target, ConnectionConstants.PORT)
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(self._on_connected_to_server)
		multiplayer.connection_failed.connect(self._on_connection_failed)
		multiplayer.server_disconnected.connect(self._on_server_disconnected)
	else:
		push_warning("already connected")

func _on_connected_to_server():
	print_debug("connected")
	connected = true

func _on_connection_failed():
	print_debug("connection failed")
	connected = false
	
func _on_server_disconnected():
	print_debug("disconnected")
	connected = false

func call_move_x_action(input: float):
	rpc("move_x_action", input)

func call_move_y_action(input: float):
	rpc("move_y_action", input)

func call_move_action(input: Vector2):
	rpc("move_action", input)

@rpc("any_peer")
func receive_object_position_update(id: int, position: Vector2):
	super.receive_object_position_update(id, position)
	object_position_update_event.emit(id, position)

@rpc("any_peer")
func receive_object_created(id: int, type: String, initial_position: Vector2):
	super.receive_object_created(id, type, initial_position)
	object_created_event.emit(id, type, initial_position)


@rpc("any_peer")
func receive_object_removed(id: int):
	super.receive_object_removed(id)
	object_removed_event.emit(id)
