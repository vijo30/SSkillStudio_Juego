extends ProgressBar

var stopped = false

func _ready():
	Manager.progress_bar = self

func pause():
	stopped = true

func _process(delta):
	if not stopped:
		self.value += 5*delta #cambiarlo 
		if Input.is_action_just_pressed("attack") and self.value >= 99.9:
			self.value = 0
