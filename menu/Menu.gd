extends Control

func _ready():
	Manager.actualHealth = 100
	Manager.pizzas = 3
	Manager.actualLevel = 0
	$GameMenu/StartButton.grab_focus()

func _on_StartButton_pressed():
		get_tree().change_scene("res://levels/Level_1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_FullscreenButton_pressed():
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)


func _on_Switch_pressed():
	$GameMenu.visible = !$GameMenu.visible
	$GameSettings.visible = !$GameSettings.visible


func _on_Switch2_pressed():
	$Controls.visible = !$Controls.visible
	$GameSettings.visible = !$GameSettings.visible
