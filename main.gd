extends Node2D

@onready var connection_handler: ConnectionHandler = %ConnectionHandler
@onready var label: Label = %Label
@onready var player_resorce: Resource = preload("res://shared/player.tscn")

const ObjectTypeResource = preload("res://shared/object_type.gd")

# better do it this way - just works only with goddot 4.4
#var scene_elements: Dictionary[int, GameObject] = {}
var scene_elements: Dictionary = {}
var last_direction: Vector2 = Vector2.ZERO

func _ready():
	connection_handler.object_position_update_event.connect(_object_position_update)
	connection_handler.object_created_event.connect(_object_created)
	connection_handler.object_removed_event.connect(_object_removed_event)
	connection_handler.receive_game_state_event.connect(_receive_game_state_event)
	connection_handler.connect_to_server("127.0.0.1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if connection_handler.connected && connection_handler.joined:
		if (direction != last_direction):
			last_direction = direction
			connection_handler.call_move_action(direction)

func _object_position_update(id: int, new_position: Vector2, direction: Vector2):
	if (!scene_elements.has(id)):
		return
	scene_elements.get(id).position = new_position
	
func _object_created(id: int, type: ObjectTypeResource.ObjectType, initial_position: Vector2):
	print("_object_created")
	if (!scene_elements.has(id)):
		var object: GameObject = player_resorce.instantiate() as GameObject
		scene_elements[id] = object
		scene_elements.get(id).position = initial_position
		add_child(scene_elements.get(id))

func _object_removed_event(id: int):
	if (scene_elements.has(id)):
		remove_child(scene_elements.get(id))
		scene_elements.erase(scene_elements.get(id))

func _receive_game_state_event(active_connections: int, max_connections: int):
	label.text = str(active_connections) + " / " + str(max_connections)

func _on_button_pressed():
	connection_handler.call_join_game()
