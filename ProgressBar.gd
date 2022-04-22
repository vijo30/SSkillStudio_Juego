extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.value += 20*delta #cambiarlo 
	if Input.is_action_just_pressed("attack") and self.value >= 99.9:
		self.value = 0
