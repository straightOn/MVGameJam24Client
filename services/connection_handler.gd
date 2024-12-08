extends RpcBase

class_name ConnectionHandler

const GamePhase = preload("res://shared/game_phase.gd")

signal object_position_update_event(id: int, position: Vector2, direction: Vector2)
signal object_created_event(id: int, type: ObjectTypeResource.ObjectType, initial_position: Vector2, name: String)
signal object_removed_event(id: int)
signal receive_game_state_event(active_connections: int, max_connections: int)
signal receive_next_wave_event(wave: int)
signal receive_level_up_event(id: int, level: int, newHp: float, newMaxHp: float)
signal receive_remaining_phase_time_event(id: int, seconds: float)
signal receive_object_attacks_event(id: int, direction: Vector2)
signal receive_object_takes_damage_event(id: int, damage: float, newHp: float)
signal receive_remaining_time_event(seconds: int)
signal receive_new_player_phase_event(id: int, new_phase: GamePhaseResource.Phase)
signal receive_player_phase_remaining_event(id: int, remaining: int)
signal receive_game_over_event(id: int, kills: int, alive_time: int)

var connected: bool = false
var joined: bool = false
	
func connect_to_server(target: String):
	print_debug("connecting to server: ", target)
	if (!connected):
		var peer = WebSocketMultiplayerPeer.new()
		peer.create_client(target + ':' + str(ConnectionConstants.PORT))
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

func call_join_game(name: String):
	rpc("join_game", name)
	joined = true

@rpc("any_peer")
func receive_object_position_update(id: int, position: Vector2, direction: Vector2):
	super.receive_object_position_update(id, position, direction)
	object_position_update_event.emit(id, position, direction)

@rpc("any_peer")
func receive_object_created(id: int, type: ObjectTypeResource.ObjectType, initial_position: Vector2, hp: float, max_hp: float, name: String):
	super.receive_object_created(id, type, initial_position, hp, max_hp, name)
	object_created_event.emit(id, type, initial_position, name)

@rpc("any_peer")
func receive_object_removed(id: int):
	#super.receive_object_removed(id)
	object_removed_event.emit(id)
	
@rpc("any_peer")
func move_action(input: Vector2):
	pass

@rpc("any_peer")
func receive_game_state(active_connections: int, max_connections: int):
	super.receive_game_state(active_connections, max_connections)
	receive_game_state_event.emit(active_connections, max_connections)

@rpc("any_peer")
func receive_next_wave(wave: int):
	#super.receive_next_wave(wave)
	receive_next_wave_event.emit(wave)
	
@rpc("any_peer")
func receive_new_player_phase(id: int, new_phase: GamePhaseResource.Phase ):
	super.receive_new_player_phase(id, new_phase)
	receive_new_player_phase_event.emit(id, new_phase)
	
@rpc("any_peer")
func receive_level_up(id: int, level: int, newHp: float, newMaxHp: float):
	super.receive_level_up(id, level, newHp, newMaxHp)
	receive_level_up_event.emit(id, level, newHp, newMaxHp)
	
@rpc("any_peer")
func receive_remaining_phase_time(id: int, seconds: float):
	super.receive_remaining_phase_time(id, seconds)
	receive_remaining_phase_time_event.emit(id, seconds)

@rpc("any_peer")
func receive_object_attacks(id: int, direction: Vector2):
	#super.receive_object_attacks(id, direction)
	receive_object_attacks_event.emit(id, direction)
	
@rpc("any_peer")
func receive_object_takes_damage(id: int, damage: float, newHp: float):
	#super.receive_object_takes_damage(id, damage, newHp)
	receive_object_takes_damage_event.emit(id, damage, newHp)
	
@rpc("any_peer")
func receive_remaining_time(remaining: int):
	#super.receive_remaining_time(remaining)
	receive_remaining_time_event.emit(remaining)

@rpc("any_peer")
func receive_player_phase_remaining(id: int, remaining: int):
	#super.receive_player_phase_remaining(id, remaining)
	receive_player_phase_remaining_event.emit(id, remaining)

@rpc("any_peer")
func receive_game_over(id: int, kills: int, alive_time: int):
	super.receive_game_over(id, kills, alive_time)
	receive_game_over_event.emit(id, kills, alive_time)
