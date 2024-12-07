class_name HealthBar extends Control

@export var hp: float = 5
@export var hp_max: float = 10

var initial_width: float

func _ready() -> void:
	initial_width = $Fill.size.x

func _process(delta: float) -> void:
	update_fill()
	pass
	
func set_hps(hp_new: float, hp_max_new: float):
	hp = hp_new
	hp_max = hp_max_new
	
func update_fill():
	if hp <= 0.0:
		$Fill.size.x = 0
		return
		
	var health_ratio = hp / hp_max
	$Fill.size.x = health_ratio * initial_width
