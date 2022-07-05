extends Panel

var timerStop = false

func _ready():
	timerStop = false
	if Manager.pizzas >= 1:
		$Lifes/pizza1.visible = true
	if Manager.pizzas >= 2:
		$Lifes/pizza2.visible = true
	if Manager.pizzas >= 3:
		$Lifes/pizza3.visible = true	

# _delta, no se utilizará para nada
func _process(_delta):
	#muestra el tiempo en minutos:segundos
	if not timerStop:
		$TimeLabel.text = "Tiempo Restante: %d:%02d" % [floor($TimeLeft.time_left / 60), int($TimeLeft.time_left) % 60]


func _on_Button_pressed():
	# get_tree().paused = false
	Manager.pizzas -= 1
	Manager.actualHealth = 100
	$backTheme.volume_db = 0
	get_tree().reload_current_scene()

func pauseTimer():
	timerStop = true

func _on_TimeLeft_timeout():
	$backTheme.volume_db = -10
	$ProgressBar.pause()
	$turutuTimer.start()

func _on_Player_killed():
	$backTheme.volume_db = -10
	$ProgressBar.pause()
	pauseTimer()
	$turutuTimer.start()
		
		
func _on_GameOverTimer_timeout():
	get_tree().change_scene("res://credits/GodotCredits.tscn")

func _on_turutuTimer_timeout():
	if Manager.pizzas == 0:
		$GameOver.visible = true
		$GameOverTimer.start()
	else:
		$Button.visible = true
