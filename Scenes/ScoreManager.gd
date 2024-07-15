extends Label


var score : int = 0

func increase_score (amount: int):
	score += amount
	text = "Score: " + str(score)


