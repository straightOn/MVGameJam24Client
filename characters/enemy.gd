class_name Enemy extends Node2D

@onready var damage_numbers_origin = %DamageNumbersOrigin

const ObjectTypeResource = preload("res://shared/object_type.gd")
const GamePhase = preload("res://shared/game_phase.gd")

var time_since_last_hit: float = 10
var delay_for_hit: float = 1

# Stats
var hp: float = 10
var hp_max: float = 10
var hp_base: float = 10
var xp: float = 1
var att: float = 1
var att_base: float = 1
var enemy_type: ObjectTypeResource.ObjectType = ObjectTypeResource.ObjectType.Bug
var enemy_phase: GamePhase.Phase = GamePhase.Phase.DAY

func _ready() -> void:
	hp = hp_base * pow(1.1, Gamemanager.get_wave() - 1)
	hp_max = hp
	xp = Gamemanager.get_wave()
	att = att_base * pow(1.1, Gamemanager.get_wave() - 1)
	
	if $AnimationPlayer:
		$AnimationPlayer.play("run")

func get_enemy_type():
	return enemy_type

func get_xp():
	return xp

func get_phase():
	return enemy_phase
	
func _process(delta: float) -> void:
	if $HealthBar != null:
		$HealthBar.set_hps(hp, hp_max)
		
func take_damage(damage: float):
	if damage_numbers_origin:
		var is_critical: bool = false
		DamageNumbers.display_number(damage, damage_numbers_origin.global_position, is_critical)

func set_hp(hpNew: float):
	hp = hpNew

func set_max_hp(maxHpNew: float):
	hp_max = maxHpNew
