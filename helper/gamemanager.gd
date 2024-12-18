extends Node

enum ENEMY_TYPE { BUG, GHOST }
enum PHASE { DAY, NIGHT }

static var _current_wave: int = 0
static var _current_player_count: int = 0
static var _current_status: String = "Idle" # Possible statuses: "Idle", "Ingame", "Dead"
static var _enemy_dict: Dictionary

static var _time_base: float = 5;
static var _current_time: float = _time_base;
static var _additional_time_per_wave: float = 5
static var _max_waves: int = 20

static var _flip_char: bool = false

func _ready() -> void:
	reset_game()
	
	_enemy_dict = {
		ENEMY_TYPE.BUG: [],
		ENEMY_TYPE.GHOST: []
	}
	
static func game_won() -> bool:
	return _current_wave > _max_waves
	
static func set_remaining_time(seconds: float):
	_current_time = seconds
	
static func get_remaining_time(delta: float) -> int:
	return 60
	pass

static func get_wave() -> int:
	return _current_wave

static func get_player_count() -> int:
	return _current_player_count

static func get_status() -> String:
	return _current_status

static func get_enemy_list(enemy_type: ENEMY_TYPE) -> Array:
	return _enemy_dict.get(enemy_type)

# Public setter methods
static func set_wave(wave: int) -> void:
	_current_wave = wave

static func add_player() -> void:
	_current_player_count += 1

static func remove_player() -> void:
	if _current_player_count > 0:
		_current_player_count -= 1

static func set_status_ingame() -> void:
	_current_status = "Ingame"

static func set_status_dead() -> void:
	_current_status = "Dead"

static func can_add_enemy(enemy_type: ENEMY_TYPE) -> bool:
	print_debug(_enemy_dict)
	print_debug(_enemy_dict.get(enemy_type))
	return _enemy_dict.get(enemy_type).size() < get_max_enemies()
	
static func get_max_enemies() -> int:
	return 10 * pow(1.08, _current_wave)

static func add_enemy(enemy: Node, enemy_type: ENEMY_TYPE) -> bool:
	# Adds an enemy if there's room
	if can_add_enemy(enemy_type):
		_enemy_dict.get(enemy_type).append(enemy)
		return true
	return false

static func remove_enemy(enemy: Node, enemy_type: ENEMY_TYPE) -> bool:
	# Removes an enemy if it exists in the list
	if enemy in _enemy_dict.get(enemy_type):
		_enemy_dict.get(enemy_type).erase(enemy)
		return true
	return false

# Optional: Reset method to reset game data
static func reset_game() -> void:
	_current_wave = 1
	_current_player_count = 1
	_current_status = "Idle"	
	_enemy_dict.clear()
	_current_time = _time_base

static func flip_char(flip: bool):
	_flip_char = flip
	
static func get_flip_char():
	return _flip_char
