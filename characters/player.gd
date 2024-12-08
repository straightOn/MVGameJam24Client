extends Node2D

class_name Player

const GamePhase = preload("res://shared/game_phase.gd")

@onready var animation_player = %AnimationPlayer
@onready var damage_numbers_origin = %DamageNumbersOrigin
@onready var label_element: Label = %Label
@onready var label_phase_timer: Label = %LabelPhaseTimer
@onready var attack_player: AudioStreamPlayer2D = %AttackPlayer
@onready var damage_player: AudioStreamPlayer2D = %DmgPlayer
@onready var enemy_attack_player: AudioStreamPlayer2D = %EnemyAttackPlayer

const SPEED: float = 300

var maxHp: float
var hp: float
var remaining_phase_time: float = 60
var label: String
var current_phase: GamePhase.Phase = GamePhase.Phase.DAY

func _ready():
	animation_player.play("idle")
	label_element.text = label
	#hp = max(hp, 10)
	#maxHp = max(maxHp, 10)

func _process(delta: float) -> void:
	$HealthBar.set_hps(hp, maxHp)
	
	$Sprite.flip_h = Gamemanager.get_flip_char()
	label_phase_timer.text = str(remaining_phase_time)

func get_phase():
	return current_phase

func take_damage(damage: float):
	enemy_attack_player.play()
	var is_critical: bool = false
	animation_player.play("get_hit")
	animation_player.queue("idle")
	DamageNumbers.display_number(damage, damage_numbers_origin.global_position, is_critical)

func level_up(level: int):
	print_debug("TODO show new level")

func set_hp(hpNew: float):
	hp = hpNew

func set_max_hp(maxHpNew: float):
	maxHp = maxHpNew

func set_remaining_time(seconds: float):
	remaining_phase_time = seconds
	
func attack(direction: Vector2):
	attack_player.play()
	animation_player.play("attack")
	animation_player.queue("idle")
	
func die(id: int, kills: int, alive_time: int):
	pass
	# display passed infos
	#print_debug(id)
	#print_debug(kills)
	#print_debug(alive_time)
	#print_debug(game_over)
	#if game_over:
		#game_over.visible = true

func switch_phase(new_phase: GamePhase.Phase):
	current_phase = new_phase
