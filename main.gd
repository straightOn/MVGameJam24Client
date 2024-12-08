extends Node2D

@onready var connection_handler: ConnectionHandler = %ConnectionHandler
@onready var label: Label = %Label
@onready var ghost_layer: CanvasLayer = %GhostLayer
@onready var player_resorce: Resource = preload("res://characters/player.tscn")
@onready var bug_resource: Resource = preload("res://characters/bug.tscn")
@onready var ghost_resource: Resource = preload("res://characters/ghost.tscn")
@onready var game_over_overlay: GameOver = %Gameover
@onready var current_wave_label: Label = %CurrentWave
@onready var start_menu: StartMenu = %StartMenu

const ObjectTypeResource = preload("res://shared/object_type.gd")
const GamePhase = preload("res://shared/game_phase.gd")

# better do it this way - just works only with goddot 4.4
#var scene_elements: Dictionary[int, GameObject] = {}
var scene_elements: Dictionary = {}
var last_direction: Vector2 = Vector2.ZERO
var current_wave: int = 1
var my_player_id: int = 0

func _ready():
	start_menu.start_game.connect(_call_join_game)
	
	connection_handler.object_position_update_event.connect(_object_position_update)
	connection_handler.object_created_event.connect(_object_created)
	connection_handler.object_removed_event.connect(_object_removed_event)
	
	connection_handler.receive_game_state_event.connect(_receive_game_state_event)	
	connection_handler.receive_next_wave_event.connect(_next_wave)
	connection_handler.receive_level_up_event.connect(_player_levels_up)
	connection_handler.receive_remaining_phase_time_event.connect(_set_remaining_phase_time)
	
	connection_handler.receive_object_attacks_event.connect(_object_attacks)
	connection_handler.receive_object_takes_damage_event.connect(_object_takes_damage)
	
	connection_handler.receive_remaining_time_event.connect(_set_remaining_wave_time)
	connection_handler.receive_new_player_phase_event.connect(_update_player_phase)
	connection_handler.receive_player_phase_remaining_event.connect(_set_player_phase_remaining)
	connection_handler.receive_game_over_event.connect(_set_player_game_over)
	
	connection_handler.connect_to_server("127.0.0.1")
	
	game_over_overlay.gameover_join_game_event.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_wave_label.text = "Wave: %d" % current_wave
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if connection_handler.connected && connection_handler.joined:
		if (direction != last_direction):
			last_direction = direction
			connection_handler.call_move_action(direction)
			
			Gamemanager.flip_char(direction.x < 0.0)
	
	enemy_transparency()
			
func enemy_transparency():
	var player = scene_elements.get(my_player_id)
		
	if not player:
		return
	
	for objectId in scene_elements:
		var object = scene_elements.get(objectId)

		if object is Enemy:
			if player.get_phase() != object.get_phase():
				object.modulate.a = 0.25
			else:
				object.modulate.a = 1
	
	pass

func _object_position_update(id: int, new_position: Vector2, direction: Vector2):
	if (!scene_elements.has(id)):
		return
	scene_elements.get(id).position = new_position
	
func _object_created(id: int, type: ObjectTypeResource.ObjectType, initial_position: Vector2, name: String, hp: int, hp_max: int):		

	if (!scene_elements.has(id)):
		var object = null
		
		match type:
			ObjectTypeResource.ObjectType.Player:
				object = player_resorce.instantiate() as Player
				object.label = name
			ObjectTypeResource.ObjectType.Bug:
				object = bug_resource.instantiate() as BugEnemy
			ObjectTypeResource.ObjectType.Ghost:
				object = ghost_resource.instantiate() as Ghost
		
		if object != null:
			object.set_hp(hp)
			object.set_max_hp(hp_max)
			
			scene_elements[id] = object
			scene_elements.get(id).position = initial_position
			add_child(scene_elements.get(id))

func _object_removed_event(id: int):
	if (scene_elements.has(id)):
		var element = scene_elements.get(id)
		remove_child(element)
		scene_elements.erase(id)
		element.queue_free()

func _receive_game_state_event(peer_id: int, active_connections: int, max_connections: int):
	label.text = str(active_connections) + " / " + str(max_connections)
	my_player_id = peer_id

func _call_join_game():
	for key in scene_elements.keys():
		_object_removed_event(key)
	connection_handler.call_join_game(str(gamer_tag.text))

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
	ghost_layer.visible = phase == GamePhase.Phase.NIGHT
	
	var player: Player = scene_elements.get(id)
	
	if player:
		if player is Player:
			player.switch_phase(phase)
	
func _player_levels_up(id: int, level: int, newHp: float, newMaxHp: float):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)
	
	if player:
		player.level_up(level)
		player.set_hp(newHp)
		player.set_max_hp(newMaxHp)
	
func _set_remaining_phase_time(id: int, seconds: float):
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)

	if player:
		player.set_remaining_time(seconds)

func _object_attacks(id: int, direction: Vector2):
	if (!scene_elements.has(id)):
		return
		
	var object = scene_elements.get(id)
	
	if object && object is Player:
		(object as Player).attack(direction)

func _object_takes_damage(id: int, damage: float, newHp: float):
	if (!scene_elements.has(id)):
		return
		
	var object = scene_elements.get(id)
	
	if object is Player or object is Enemy:
		object.take_damage(damage)
		object.set_hp(newHp)
	
	pass
	
func _set_remaining_wave_time(seconds: int):
	Gamemanager.set_remaining_time(float(seconds))
	pass

func _set_player_game_over(id: int, kills: int, alive_time: int):
	game_over_overlay.visible = true
	game_over_overlay.set_stats(alive_time, kills)
	ghost_layer.visible = false
	
	if (!scene_elements.has(id)):
		return
		
	var player: Player = _get_player(id)
	
	if player:
		player.die(id, kills, alive_time)

func _set_player_phase_remaining(id: int, seconds: int):
	if (!scene_elements.has(id)):
		return

	var player: Player = _get_player(id)
	
	if player:
		player.set_remaining_time(float(seconds))
