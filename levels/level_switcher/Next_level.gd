extends AnimatedSprite

signal entered

func _on_Hitbox_area_entered(_area):
	emit_signal("entered")
	Manager.actualHealth = 100
	Manager.actualLevel += 1
	if Manager.actualLevel == 3: 
		get_tree().change_scene("res://credits/GodotCredits.tscn")
	get_tree().change_scene("res://levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
