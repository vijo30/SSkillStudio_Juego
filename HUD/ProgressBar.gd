extends ProgressBar


func _ready():
	Manager.progress_bar = self


func _process(delta):
	self.value += 20*delta #cambiarlo 
	if Input.is_action_just_pressed("attack") and self.value >= 99.9:
		self.value = 0
