extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if event.is_action_pressed("pause_game"): 
		get_tree().paused = true
		self.visible = true

func _on_ContinueButton_pressed():
	get_tree().paused = false
	self.visible = false


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://menu/Menu.tscn")
	

func _on_QuitGameButton_pressed():
	get_tree().paused = false
	get_tree().quit()
