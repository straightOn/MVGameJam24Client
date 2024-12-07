extends Node2D

class_name Player

@onready var animation_player = %AnimationPlayer
@onready var damage_numbers_origin = %DamageNumbersOrigin
@onready var game_over: GameOver = %Gameover
@onready var label_element: Label = %Label

const SPEED: float = 300

var maxHp: float
var hp: float
var remaining_phase_time: float = 60
var label: String

func _ready():
	animation_player.play("idle")
	label_element.text = label

func _process(delta: float) -> void:
	$HealthBar.set_hps(hp, maxHp)
	
	$Sprite.flip_h = Gamemanager.get_flip_char()

func take_damage(damage: float):
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
	animation_player.play("attack")
	animation_player.queue("idle")
	
func die(id: int, kills: int, alive_time: int):
	# display passed infos
	if game_over:
		game_over.visible = true
