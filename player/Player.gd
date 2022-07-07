extends KinematicBody2D

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
var climb = false

# Attack var
var canIAttack = false
var attacking = false
onready var timer = get_node("Timer")
onready var next_level = get_tree().get_root().get_node("Level_"+ str(int(get_tree().current_scene.name))+"/Next_level")

# callampitas
var actualMushroom
var mushroomSound


# Damaged var
var damaged = false
onready var dtimer = get_node("dmgTimer")
onready var stimer = get_node("SpikeTick")
# Activate animations
func _ready(): 
	_set_health(Manager.actualHealth)
	$AnimationTree.active = true
	next_level.connect("entered", self, "handleNextLevel")


func _on_CollisionArea_body_entered(body):
	if body.is_in_group('spikes'): 
		print("ouch")
		damaged = true
		damage(10)
		stimer.start()


func _on_CollisionArea_body_exited(body):
	if body.is_in_group('spikes'):
		stimer.stop()


# INNOVATIVE MECHANICS

func _on_climb_wall_body_entered(body): 
	if body.is_in_group('tilemap'): climb = true

func _on_climb_wall_body_exited(body): 
	if body.is_in_group('tilemap'): climb = false
	
func handleNextLevel():	
	print("res://levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	

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
		if is_on_floor(): grounded = true
		if not is_on_floor(): grounded = false
		# set horizontal velocity
		var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.x = mve * move_speed
		
		if mve > 0: 
			$HeroKnight.flip_h = false
		if mve < 0: 
			$HeroKnight.flip_h = true
		# set direction of climb_wall	
		if mve != 0: lastDir = mve
		$climb_wall.rotation_degrees = lastDir * 90
		$AttackDetector.rotation_degrees = lastDir * 90
		
		# Vertical movement	
		if climb: velocity.y = 0 		
		# apply gravity
		if not climb: velocity.y += gravity * delta
		
		# move upwards or downwards on walls
		if Input.is_action_pressed("move_up") and (climb): velocity.y -= move_speed
		if Input.is_action_pressed("move_down") and (climb): velocity.y += move_speed

		# actually move the player
		velocity = move_and_slide(velocity, Vector2.UP)
				
		# animations	
		
		if (grounded) and (not attacking): 
			$AnimationTree.set("parameters/in_air_state/current",0)		
		if velocity == Vector2.ZERO and (not attacking): $AnimationTree.set("parameters/movement/current",0)
		if abs(velocity.x) >0 and (grounded) : 
			$AnimationTree.set("parameters/movement/current",1)
			attacking = false
				# attack implementation
		if Input.is_action_pressed("attack") and canIAttack and (not climb):
			timer.start()
			canIAttack = false
			attacking = true
			$AnimationTree.set("parameters/movement/current",2)
	
		if attacking: 
	
			$AttackDetector/CollisionShape2D.disabled = false	
		if not attacking: $AttackDetector/CollisionShape2D.disabled = true
		
		if (not climb) and (not grounded) and (not attacking): $AnimationTree.set("parameters/in_air_state/current",1)
		
		
		if climb:
			$AnimationTree.set("parameters/in_air_state/current",2)
			if velocity.y == 0: $AnimationTree.set("parameters/on_wall/current",0)
			else: $AnimationTree.set("parameters/on_wall/current",1)
		
		
		if damaged and not attacking: $AnimationTree.set("parameters/in_air_state/current",3)

func _on_Timer_timeout(): attacking = false



func damage(amount):
	if amount == 10:
		$Sounds/pain1.play()
	_set_health(health - amount)
	dtimer.start()

func kill():
	dead = true
	$Sounds/death.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionArea/CollisionShape2D.set_deferred("disabled", true)
	$climb_wall/CollisionShape2D.set_deferred("disabled", true)
	$AttackDetector/CollisionShape2D.set_deferred("disabled",true)
	$AnimationTree.set("parameters/in_air_state/current",3)
	$AnimationTree.set("parameters/is_damaged/current",1)
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

func _on_CollisionArea_area_entered(area):
	if area.is_in_group('enemieAttack'):
		$Sounds/pain2.play()
		print("ouch")
		damaged = true
		damage(30)
	if area.is_in_group("killerArea"):
		damage(100)
	if area.is_in_group("bullet"):
		damaged = true
		damage(10)

func consumeMushroom(mushroom):
	$eatTimer.start()
	$Sounds/eat.play()
	mushroomSound = "Sounds/mushroom" + mushroom
	actualMushroom = mushroom

func _on_eatTimer_timeout():
	if actualMushroom == "1":
		_set_health(health-10)
	if actualMushroom == "2":
		_set_health(health+10)
	if actualMushroom == "3":
		self.position.x = Manager.teleportPlace[Manager.actualLevel][0]
		self.position.y = Manager.teleportPlace[Manager.actualLevel][1]
	get_node(mushroomSound).play()


