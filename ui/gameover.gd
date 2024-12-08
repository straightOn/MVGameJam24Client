class_name GameOver extends Node2D

@onready var seconds_alive: Label = %SecondsAlive
@onready var kills: Label = %Kills
@onready var connection_handler: ConnectionHandler = %ConnectionHandler

func _on_button_pressed() -> void:
	connection_handler.call_join_game("noob")
	visible = false

func set_stats(seconds: int, killCount: int):
	seconds_alive.text = str(seconds)
	kills.text = str(killCount)
