extends Label

var lives: int = 10

func decrease_lives():
	lives -= 1
	text = "Lives: " + str(lives)
	if lives < 1:
		# TODO End game and show high score.
		pass
