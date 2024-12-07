extends Node2D

class_name Player

@onready var animation_player = %AnimationPlayer
@onready var damage_numbers_origin = %DamageNumbersOrigin

const SPEED: float = 300
const GamePhase = preload("res://shared/game_phase.gd")

var maxHp: float
var hp: float
var remaining_phase_time: float = 60
var phase: GamePhase.Phase = GamePhase.Phase.DAY

func _ready():
	animation_player.play("idle") 

#func _physics_process(delta):
	#move_and_slide()

#func move_action(direction: Vector2):
	#velocity = direction * SPEED
	#print_debug("jo")

func switch_phase(newPhase: GamePhase.Phase):
	phase = newPhase
	
func _process(delta: float) -> void:
	$HealthBar.set_hps(hp, maxHp)
	
	$Sprite.flip_h = Gamemanager.get_flip_char()

func take_damage(damage: float):
	var is_critical: bool = false
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position, is_critical)

func level_up(level: int):
	print_debug("TODO show new level")

func set_hp(hpNew: float):
	hp = hpNew

func set_max_hp(maxHpNew: float):
	maxHp = maxHpNew

func set_remaining_time(seconds: float):
	remaining_phase_time = seconds
