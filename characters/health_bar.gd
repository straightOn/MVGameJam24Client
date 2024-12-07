class_name HealthBar extends Node2D

@export var hp: float = 10
@export var hp_max: float = 10

func _process(delta: float) -> void:
	$HP.text = "HP: %d" % hp
