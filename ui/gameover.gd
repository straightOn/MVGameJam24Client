class_name GameOver extends Node2D

func _on_button_pressed() -> void:
	#TODO: recreate player on server?!
	print_debug("reload char")
	
	visible = false
