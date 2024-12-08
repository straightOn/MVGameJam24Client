class_name StartMenu extends CanvasLayer

signal start_game(name: String)

@onready var gamer_tag: LineEdit = %Gamertag
@onready var connection_label: Label = %ConnectionLabel
@onready var button: Button = %Button

func _on_button_pressed():
	var tag = str(gamer_tag.text)
	call_start_game(tag)

func _on_gamertag_text_submitted(new_text):
	call_start_game(new_text)

func call_start_game(input: String):
	if input.length() > 0:
		start_game.emit(str(gamer_tag.text))
		visible = false	

func connection_successful():
	connection_label.text = "VERBUNDEN"
	button.disabled = false
	
func connection_failed():
	connection_label.text = "Nicht Verbunden"
	button.disabled = true
	
