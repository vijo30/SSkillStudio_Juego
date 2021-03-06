extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.red

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"A game by SSkillStudio"
	],[
		"Programming",
		"Valentina Rojas",
		"José Videla A."
	],[
		"Art",
		"Monsters Creatures Fantasy by LuizMelo",
		"Spikes by Omniclause",
		"Free Swamp 2D Tileset Pixel Art by 'Free and Premium Game Assets (GUI, Sprite, Tilesets)'",
		"m5x7 font by Daniel Linssen",
		"2D Pixel Art Portal Sprites by Elthen's Pixel Art Shop",
		"16x16 Fantasy Mushroom Pack by ssugmi",
		"Free Pixel foods by ghostpixxells",
		"Free Pixel Food by Henry Software"
	],[
		"Music",
		"Swamp 01 by Fantasy Musica (Back Theme)",
		"DOS-88 Synthwave Music Library by DOS88 (Credits Theme)"
	],[
		"Sound Effects",
		"Generic Male Voice Pack by The Danicon Show",
		"Monster Sounds Volume 2 by Ogrebane",
		"41 Short, Loopable Background Music Files by joshuuu",
		"QuickSounds.com",
		"Sound Effects Pack 2 by phoenix1291",
		"Win Jingle by Fupi",
		"20 Sword Sound Effects (Attacks and Clashes) by StarNinjas"
	],[
		"Testers",
		"Valentina Rojas",
		"José Videla A.",
		"Milwer7",
		"Melanie Jalea"
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		""
	],[
		"Special thanks",
		"My parents",
		"My friends",
		"",
		"Mario por botar el ramo RIP",
		"Milwer q me ayudó mucho y lo quiero mucho",
		"Melanie Jalea por apoyarme y la quiero mucho",
		"Mi familia q lxs quiero mucho",
		"Damian por su buena disposición xD",
		"Elías por dejarme presentar online uwu"
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		# NOTE: This is called when the credits finish
		# - Hook up your code to return to the relevant scene here, eg...
		get_tree().change_scene("res://menu/Menu.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
