extends PanelContainer

func _on_button_pressed():
	var _main_game_scene = load("res://Scenes/main.tscn")
	var game_instance = _main_game_scene.instantiate()
	get_tree().root.add_child(game_instance)
	queue_free()
