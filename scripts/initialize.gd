extends Node3D
var score = 0
var misses = 0
var currTarget;
var xr_interface: XRInterface
var tween
var gameStarted = false;

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully!")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized. Please check if your headset is connected.")

func _process(delta):
	if gameStarted:
		if currTarget:
			if $Ball.global_position == currTarget:
				misses += 1
				$Misses.text = "Misses: " + str(misses)	
				set_random_start()
		if $XROrigin3D/LeftController.global_position.distance_to($Ball.global_position) < $Ball/MeshInstance3D.mesh.radius or $XROrigin3D/RightController.global_position.distance_to($Ball.global_position) < $Ball/MeshInstance3D.mesh.radius:
			tween.stop()
			score += 1
			$Saves.text = "Saves: " + str(score)
			set_random_start()

func animate_ball():
	if gameStarted:
		await get_tree().create_timer(1).timeout
		tween = create_tween()
		tween.tween_property($Ball, "position",get_random_target(), 1)

func set_random_start():
	if gameStarted:
		## Set Ball To Random Location
		var cornerPos1 = $KickAreaCorner1.position
		var cornerPos2 = $KickAreaCorner2.position
		var random_x = randf_range(cornerPos1.x,cornerPos2.x)
		var random_z = randf_range(cornerPos1.z,cornerPos2.z)
		$Ball.position.x = random_x
		$Ball.position.z = random_z
		$Ball.position.y = $Ball/MeshInstance3D.mesh.radius

func get_random_target():
	var goalPost1 = $GoalPost1.position
	var goalPost2 = $GoalPost2.position
	var random_y = randf_range(goalPost1.y, goalPost2.y)
	var random_x = randf_range(goalPost1.x, goalPost2.x)
	currTarget = Vector3(random_x, random_y, goalPost1.z)
	return currTarget
#	print($XROrigin3D/LeftController.position)
#	return $XROrigin3D/LeftController.position


func _on_left_controller_button_pressed(name):
	if name == "by_button":
		set_random_start()
	if name == "ax_button":
		animate_ball()

func _on_right_controller_button_pressed(name):
	if name == "by_button":
		set_random_start()
	if name == "ax_button":
		animate_ball()


func _on_button_pressed():
	$SpatialMenu.visible = false
	gameStarted = true
