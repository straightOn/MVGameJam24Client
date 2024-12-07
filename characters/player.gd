extends GameObject

class_name Player

const SPEED: float = 300
const GamePhase = preload("res://shared/game_phase.gd")

var maxHp: float
var hp: float
var remaining_phase_time: float = 60

func _physics_process(delta):
	move_and_slide()

func move_action(direction: Vector2):
	velocity = direction * SPEED

func switch_phase(newPhase: GamePhase.Phase):
	phase = newPhase

func take_damage(damage: float):
	print_debug("TODO show damage taken")

func level_up(level: int):
	print_debug("TODO show new level")

func set_hp(hpNew: float):
	hp = hpNew

func set_max_hp(maxHpNew: float):
	maxHp = maxHpNew

func set_remaining_time(seconds: float):
	remaining_phase_time = seconds
