extends KinematicBody2D

class_name Player

signal health_updated(health)
signal killed()

export var move_speed := 50
export var gravity := 2000

var velocity := Vector2.ZERO

# Health

export var max_health = 100
onready var health = max_health setget _set_health

# Death
var dead = false

# Grounded
var grounded = false
# Enable gravity
var grv = true
# Direction of climb_wall
var lastDir = 0

# Climbing var
var climbing = false

# Attack var
var canIAttack = false
var attacking = false
onready var timer = get_node("Timer")
onready var next_level = get_parent().get_node("Next_level")
onready var animations = $AnimationTree

# Damaged var
var damaged = false
onready var dtimer = get_node("dmgTimer")
onready var stimer = get_node("SpikeTick")
# Activate animations
func _ready(): 
	animations.active = true
	next_level.connect("entered", self, "handleNextLevel")


# SIGNALS
func _on_CollisionArea_body_entered(body):
	if body.is_in_group('spikes'): 
		print("ouch")
		damaged = true
		damage(10)
		stimer.start()
	

func _on_CollisionArea_body_exited(body):
	stimer.stop()


# INNOVATIVE MECHANICS
func _on_GroundDetector_body_entered(body): if body.is_in_group('tilemap') or body.is_in_group('spikes'): grounded = true

func _on_GroundDetector_body_exited(body): if body.is_in_group('tilemap'): grounded = false

func _on_climb_wall_body_entered(body): if body.is_in_group('tilemap'): climbing = true

func _on_climb_wall_body_exited(body): if body.is_in_group('tilemap'): climbing = false
	
func handleNextLevel():	
	print("res://levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	

##	

func _process(_delta):
	if weakref(Manager.progress_bar).get_ref():
		if Manager.progress_bar.value >= 100:
			canIAttack = true
			# sonidito, cambio color en la barra, shader al player

# Character
func _physics_process(delta):
	if not dead:
		# Horizontal movement
		# reset horizontal velocity
		velocity.x = 0
		
		# set horizontal velocity
		var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.x = mve * move_speed

		if mve > 0: $HeroKnight.flip_h = false
		if mve < 0: $HeroKnight.flip_h = true
		# set direction of climb_wall	
		if mve != 0: lastDir = mve
		$climb_wall.rotation_degrees = lastDir * 90
		
		# Vertical movement	
	
		# apply gravity
		if not climbing: velocity.y += gravity * delta
		
		# move upwards or downwards on walls
		if climbing: velocity.y = 0 	
		if Input.is_action_pressed("move_up") and (climbing): velocity.y -= move_speed
		if Input.is_action_pressed("move_down") and (climbing): velocity.y += move_speed

		# actually move the player
		velocity = move_and_slide(velocity, Vector2.UP)
				
		# ANIMATIONS
		
		if (grounded) and not climbing and (not attacking): 
			animations.set("parameters/in_air_state/current",0)	 # Grounded animations set
			if mve == 0 and (not attacking): animations.set("parameters/movement/current",0) # Idle animation
		if abs(mve) > 0: 
			animations.set("parameters/movement/current",1) # Run animation
			attacking = false
		
		# attack implementation
		if Input.is_action_pressed("attack") and canIAttack and (not climbing): 
			timer.start()
			canIAttack = false
			attacking = true			
			animations.set("parameters/movement/current",2) # Attack animation	

		# Fall animation
		if (not climbing) and (not grounded) and (not attacking): animations.set("parameters/in_air_state/current",1)
		
		if climbing:
			animations.set("parameters/in_air_state/current",2) # Climb animation set
			if velocity.y == 0: animations.set("parameters/on_wall/current",0) # Climb idle animation
			else: animations.set("parameters/on_wall/current",1) # Climb animation
		
		if damaged: animations.set("parameters/in_air_state/current",3) # Damage animation




	
func _input(event):
	if event.is_action_pressed("exit_game"): get_tree().quit()


# Damage and health

func damage(amount):
	_set_health(health - amount)
	dtimer.start()

	

func kill():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionArea.set_deferred("disabled", true)
	animations.set("parameters/in_air_state/current",3)
	animations.set("parameters/is_damaged/current",1)
	stimer.stop()


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		print(str(health))
		if health == 0:
			kill()
			emit_signal("killed")





func _on_dmgTimer_timeout():
	damaged = false


func _on_SpikeTick_timeout():
	print("ouch")
	damaged = true
	damage(10)
