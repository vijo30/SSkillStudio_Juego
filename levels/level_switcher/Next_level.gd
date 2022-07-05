extends AnimatedSprite

signal entered

func _on_Hitbox_area_entered(_area):
	emit_signal("entered")
	print("entered")
	Manager.actualLevel += 1
	get_tree().change_scene("res://levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
