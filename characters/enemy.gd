class_name Enemy extends Node2D

@onready var body: CharacterBody2D = %Body
@onready var hp_label: Label = %HPLabel

const ObjectTypeResource = preload("res://shared/object_type.gd")
const GamePhase = preload("res://shared/game_phase.gd")

var time_since_last_hit: float = 10
var delay_for_hit: float = 1

# Stats
var hp: float = 10
var hp_base: float = 10
var xp: float = 1
var att: float = 1
var att_base: float = 1
var enemy_type: ObjectTypeResource.ObjectType = ObjectTypeResource.ObjectType.Bug
var enemy_phase: GamePhase.Phase = GamePhase.Phase.DAY

func _ready() -> void:
	hp = hp_base * pow(1.1, Gamemanager.get_wave() - 1)
	xp = Gamemanager.get_wave()
	att = att_base * pow(1.1, Gamemanager.get_wave() - 1)

func get_enemy_type():
	return enemy_type

func get_xp():
	return xp

func get_phase():
	return enemy_phase
