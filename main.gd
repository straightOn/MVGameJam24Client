extends Node2D

@onready var connection_handler: ConnectionHandler = %ConnectionHandler
@onready var label: Label = %Label
@onready var player_resorce: Resource = preload("res://characters/player.tscn")
@onready var bug_resource: Resource = preload("res://characters/bug.tscn")
@onready var ghost_resource: Resource = preload("res://characters/ghost.tscn")

const ObjectTypeResource = preload("res://shared/object_type.gd")
const GamePhase = preload("res://shared/game_phase.gd")

# better do it this way - just works only with goddot 4.4
#var scene_elements: Dictionary[int, GameObject] = {}
var scene_elements: Dictionary = {}
var last_direction: Vector2 = Vector2.ZERO

func _ready():
	connection_handler.object_position_update_event.connect(_object_position_update)
	connection_handler.object_created_event.connect(_object_created)
	connection_handler.object_removed_event.connect(_object_removed_event)
	
	connection_handler.receive_game_state_event.connect(_receive_game_state_event)	
	connection_handler.receive_next_wave_event.connect(_next_wave)
	connection_handler.receive_switch_player_phase_event.connect(_update_player_phase)
	connection_handler.receive_player_takes_damage_event.connect(_player_takes_damage)
	connection_handler.receive_enemy_takes_damage_event.connect(_enemy_takes_damage)
	connection_handler.receive_level_up_event.connect(_player_levels_up)
	connection_handler.receive_remaining_phase_time_event.connect(_set_remaining_phase_time)
	
	connection_handler.connect_to_server("127.0.0.1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if connection_handler.connected && connection_handler.joined:
		if (direction != last_direction):
			last_direction = direction
			connection_handler.call_move_action(direction)

func _object_position_update(id: int, new_position: Vector2, direction: Vector2):
	if (!scene_elements.has(id)):
		return
	scene_elements.get(id).position = new_position
	
func _object_created(id: int, type: ObjectTypeResource.ObjectType, initial_position: Vector2):
	print("_object_created")
	if (!scene_elements.has(id)):
		var object: GameObject = null
		
		match type:
			ObjectTypeResource.ObjectType.Player:
				object = player_resorce.instantiate() as GameObject
			ObjectTypeResource.ObjectType.Bug:
				object = bug_resource.instantiate() as GameObject
			ObjectTypeResource.ObjectType.Ghost:
				object = ghost_resource.instantiate() as GameObject
				
		if object != null:
			scene_elements[id] = object
			scene_elements.get(id).position = initial_position
			add_child(scene_elements.get(id))

func _object_removed_event(id: int):
	if (scene_elements.has(id)):
		remove_child(scene_elements.get(id))
		scene_elements.erase(scene_elements.get(id))

func _receive_game_state_event(active_connections: int, max_connections: int):
	label.text = str(active_connections) + " / " + str(max_connections)

func _on_button_pressed():
	connection_handler.call_join_game()
	$Button.visible = false

func _next_wave(wave: int):
	Gamemanager.set_wave(wave)
	
func _get_player(id: int):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = scene_elements.get(id) as Player
	
	return player
	
func _get_enemy(id: int):
	pass

func _update_player_phase(id: int, phase: GamePhase.Phase):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)
	
	if player:
		player.switch_phase(phase)

func _player_takes_damage(id: int, damage: float, newHp: float, newMaxHp: float):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)
	
	if player:
		player.take_damage(damage)
		player.set_hp(newHp)
		player.set_max_hp(newMaxHp)
	
func _player_levels_up(id: int, level: int, newHp: float, newMaxHp: float):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)
	
	if player:
		player.level_up(level)
		player.set_hp(newHp)
		player.set_max_hp(newMaxHp)
	
func _enemy_takes_damage(id: int):
	if (!scene_elements.has(id)):
		return
		
	var enemy: Enemy = _get_enemy(id)
	
	if enemy:
		pass
	
func _set_remaining_phase_time(id: int, seconds: float):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)

	if player:
		player.set_remaining_time(seconds)
