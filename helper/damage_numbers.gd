extends Node

func display_number(value: int, position: Vector2, is_critical: bool = false):
	var rng = RandomNumberGenerator.new()
	var rngArea = 15
	
	var number = Label.new()	
	number.global_position = Vector2(rng.randf_range(position.x - rngArea, position.x + rngArea), rng.randf_range(position.y, position.y - rngArea))
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	var color = "#FFF"
	
	if is_critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"

	var colors = ["#B22", "#2B2", "#22B", "#FFF"]
	var random_index = randi() % colors.size()  # Generate a random index
	var random_color = colors[random_index]    # Get the color from the list

	number.label_settings.font_color = random_color
	number.label_settings.font_size = rng.randf_range(18, 30)
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1

	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()	
