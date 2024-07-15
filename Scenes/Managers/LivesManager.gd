extends Label

@export var game_over_scene: PackedScene

var lives: int = 10

func decrease_lives():
	lives -= 1
	text = "Lives: " + str(lives)
	if lives < 1:
		end_game()
		
func end_game():
	var game_over_instance = game_over_scene.instantiate()
	get_tree().root.add_child(game_over_instance)
	get_tree().current_scene.queue_free()
