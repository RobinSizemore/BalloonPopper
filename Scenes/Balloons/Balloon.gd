extends Area3D

@export var clicks_to_pop: int = 3
@export var size_increase: float = 0.2
@export var score_increase: int = 1
@export var bob_speed: float = 2.0
@export var movement_speed: float = 1.0

var clicks = 0
var score_manager
var lives_manager
var since_spawn = 0.0
var bob_height: float = 2.0

func _ready():
	score_manager = get_node("/root/main/ScoreManager")
	lives_manager = get_node("/root/main/LivesManager")
	
func _process(delta):
	since_spawn += delta
	# Move balloon to the right
	translate(Vector3(0, 0, movement_speed) * delta)    
	# Bobbing effect
	var bobbing = sin(since_spawn * bob_speed) * 0.1 * bob_height
	translate(Vector3(0, bobbing, 0) * delta)
	# Check if off-screen and remove
	if global_transform.origin.z > 7.5: # Assuming 5 is off-screen to the right
		lives_manager.decrease_lives()
		queue_free()
	
func set_difficulty(difficulty: int = 1):
	clicks_to_pop = min(clicks_to_pop + difficulty, 10) # Ensure clicks_to_pop doesn't go below 1
	score_increase += difficulty # Increase score increment by difficulty level
	bob_speed += difficulty * 0.5 # Increase bob speed moderately with difficulty
	bob_height += difficulty * 2
	movement_speed += difficulty * 1 # Increase movement speed slightly with difficulty
	
	# Reduce the base size of the balloon based on difficulty
	var size_reduction_factor = max(1.0 - difficulty * 0.1, 0.5) # Ensure the size doesn't reduce below 50%
	scale *= size_reduction_factor

	set_color(difficulty)

func set_color(difficulty: int = 1):
	var redness = min(float(difficulty - 1) / 10, 1)
	var color = Color(redness, 1 - redness, 0)
	var mesh_instance = get_child(0)
	if mesh_instance and mesh_instance is MeshInstance3D:
		var material = mesh_instance.material_override
		if material and material is StandardMaterial3D:
			material.albedo_color = color
		else:
			print("Not Material, or Material not StandardMaterial3D")
	else:
		print("Not mesh_instance, or mesh_instance not MeshInstance3D.")
	

func pump_up():
	scale += Vector3.ONE * size_increase
	if clicks >= clicks_to_pop:
		score_manager.increase_score(score_increase)
		pop_balloon()

func pop_balloon():
	var end_scale = Vector3(0.1, 0.1, 0.1) # Target scale for shrinking
	var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var end_position = global_transform.origin + random_direction * 50 # Target position for flying off
	
	var tween = create_tween()
	# Animate scale
	tween.set_parallel(true)
	tween.tween_property(self, "scale", end_scale, 0.2)
	tween.tween_property(self, "global_position", end_position, 0.2)
	tween.tween_callback(_on_tween_completed)


func _on_tween_completed():
	queue_free()
		

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
			clicks += 1
			pump_up()
		
