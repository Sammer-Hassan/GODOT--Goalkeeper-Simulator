extends Node3D

@export var max_speed:= 2.5
@export var dead_zone := 0.2

@export var smooth_turn_speed:= 60.0
@export var smooth_turn_dead_zone := 0.2

@export var snap_turn_threshold := .9
@export var snap_turn_angle := 22.5

var input_vector_right:= Vector2.ZERO
var input_vector_left :=Vector2.ZERO

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Forward translation
	if self.input_vector_right.y > self.dead_zone || self.input_vector_right.y < -self.dead_zone:
		var movement_vector = Vector3(0, 0, max_speed * -self.input_vector_right.y * delta)
		self.position += movement_vector.rotated(Vector3.UP, global_rotation.y)
	if self.input_vector_right.x > self.dead_zone || self.input_vector_right.x < -self.dead_zone:
		var movement_vector = Vector3(max_speed * self.input_vector_right.x * delta, 0, 0)
		self.position += movement_vector.rotated(Vector3.UP, global_rotation.y)
	
	# Smooth turn
	if self.input_vector_left.x > self.smooth_turn_dead_zone || self.input_vector_left.x < -self.smooth_turn_dead_zone:
		# move to the position of the camera
		self.translate($XRCamera3D.position)

		# rotate about the camera's position
		self.rotate(Vector3.UP, deg_to_rad(smooth_turn_speed) * -self.input_vector_left.x * delta)

		# reverse the translation to move back to the original position
		self.translate($XRCamera3D.position * -1)
		




func process_input(input_name: String, input_value: Vector2):
	input_vector_left = input_value

func _on_left_controller_input_vector_2_changed(name, value):
	input_vector_right = value

