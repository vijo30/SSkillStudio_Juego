extends Panel

# _delta, no se utilizará para nada
func _process(_delta):
	#muestra el tiempo en minutos:segundos
	$TimeLabel.text = "Tiempo Restante: %d:%02d" % [floor($TimeLeft.time_left / 60), int($TimeLeft.time_left) % 60]


func _on_TimeLeft_timeout():
	get_tree().paused = true
	$Button.visible = true



func _on_Button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Player_killed():
	$Button.visible = true
	$TimeLeft.stop()
