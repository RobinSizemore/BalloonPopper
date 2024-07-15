extends Node

@export var balloon_scene: PackedScene
var right_edge = 7.5
var left_edge = -7.5
var top_edge = 4
var bottom_edge = -4
var max_difficulty = 1

# New variables
var time_since_last_spawn = 0.0
var spawn_interval = 2.0 # Initial spawn interval in seconds
var time_since_last_difficulty_increase = 0.0
var difficulty_increase_interval = 10.0 # Interval to increase difficulty

func _ready():
	randomize() # Ensure random numbers are not the same each run

func _process(delta):
	time_since_last_spawn += delta
	time_since_last_difficulty_increase += delta

	# Increase difficulty every 10 seconds
	if time_since_last_difficulty_increase >= difficulty_increase_interval:
		max_difficulty += 1
		time_since_last_difficulty_increase = 0
		spawn_interval = spawn_interval * pow(0.9, max_difficulty)
		# Optionally adjust spawn_interval based on new difficulty

	# Spawn a balloon based on the spawn interval, which could be adjusted based on difficulty
	if time_since_last_spawn >= spawn_interval:
		spawn_balloon()
		time_since_last_spawn = 0

func spawn_balloon():
	var difficulty = randi_range(1, max_difficulty)
	var balloon_instance = balloon_scene.instantiate()
	get_parent().add_child(balloon_instance)
	balloon_instance.set_difficulty(difficulty)
	balloon_instance.global_position = Vector3(0, randi_range(bottom_edge, top_edge), left_edge)
	print(difficulty)
