extends Node3D

@export var max_speed:= 2.5
@export var dead_zone := 0.2

@export var smooth_turn_speed:= 45.0
@export var smooth_turn_dead_zone := 0.2

@export var snap_turn_threshold := .9
@export var snap_turn_angle := 22.5

var input_vector:= Vector2.ZERO

var translationMode = 0;

var turnMode = 0;

var canSnap = true;

#Add a snap turn mode that will instantaneously turn by 45 degrees when they move the 
#thumbstick almost all the way (e.g., trigger values of -.9 and .9 would be reasonable). 
#The user must then return the thumbstick back to the center dead zone before they 
#can snap turn again. (4)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currentType = null
	if translationMode == 0:
		currentType = $XRCamera3D
	else:
		currentType = $LeftController
	
	# Forward translation
	if self.input_vector.y > self.dead_zone || self.input_vector.y < -self.dead_zone:
		var movement_vector = Vector3(0, 0, max_speed * -self.input_vector.y * delta)
		self.position += movement_vector.rotated(Vector3.UP, currentType.global_rotation.y)
		
	if turnMode == 0:
		# Smooth turn
		if self.input_vector.x > self.smooth_turn_dead_zone || self.input_vector.x < -self.smooth_turn_dead_zone:
			# move to the position of the camera
			self.translate($XRCamera3D.position)

			# rotate about the camera's position
			self.rotate(Vector3.UP, deg_to_rad(smooth_turn_speed) * -self.input_vector.x * delta)

			# reverse the translation to move back to the original position
			self.translate($XRCamera3D.position * -1)
	else:
		print(canSnap)
		# Smooth turn
		if (self.input_vector.x > self.snap_turn_threshold || self.input_vector.x < -self.snap_turn_threshold) && canSnap:
			canSnap = false
			# move to the position of the camera
			self.translate($XRCamera3D.position)

			# rotate about the camera's position
			self.rotate(Vector3.UP, deg_to_rad(snap_turn_angle) * -sign(input_vector.x))

			# reverse the translation to move back to the original position
			self.translate($XRCamera3D.position * -1)
		


func process_input(input_name: String, input_value: Vector2):
	if abs(input_value.x) <= .1 :
		canSnap = true;
	if input_name == "primary":
		input_vector = input_value

func _on_right_controller_button_pressed(name):
	if name == "ax_button":
		return "x"

			
	if name == "by_button":
		return "y"
