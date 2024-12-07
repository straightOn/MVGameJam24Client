class_name Ghost extends Enemy

func _ready() -> void:
	att_base = 2
	hp_base = 12
	enemy_type = ObjectTypeResource.ObjectType.Ghost
	enemy_phase = GamePhase.Phase.NIGHT
	
	super()
