class_name GameOver extends Node2D

signal gameover_join_game_event()

@onready var seconds_alive: Label = %SecondsAlive
@onready var kills: Label = %Kills
@onready var connection_handler: ConnectionHandler = %ConnectionHandler

func _on_button_pressed() -> void:
	gameover_join_game_event.emit()
	visible = false

func set_stats(seconds: int, killCount: int):
	seconds_alive.text = str(seconds)
	kills.text = str(killCount)
