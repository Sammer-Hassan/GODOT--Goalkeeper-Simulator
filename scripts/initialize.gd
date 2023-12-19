extends Node3D
var score = 0
var misses = 0
var currTarget;
var xr_interface: XRInterface
var tween
var gameStarted = false;
var ballSpeed = 1;
var animating = false
var semaphore = 1
var isStarted = true
var gameMode = 0;
var isPlaced = false;
var upperBodyOnly = false
var spin = false

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
		if spin:
			$Ball.rotate_x(ballSpeed)
		if $XROrigin3D/LeftController.global_position.distance_to($Ball.global_position) < $Ball/MeshInstance3D.mesh.radius or $XROrigin3D/RightController.global_position.distance_to($Ball.global_position) < $Ball/MeshInstance3D.mesh.radius:
			if isStarted:
				tween.stop()
				
				$AudioStreamPlayer3.play()
				score += 1
				$Saves.text = "Saves: " + str(score)
				animating = false
				spin = false
			isStarted = false
			if gameMode == 1:
				await get_tree().create_timer(1.0).timeout
				set_random_start()
				await get_tree().create_timer(1.5).timeout
				animate_ball()

func animate_ball():
	if gameStarted and isPlaced:
		isPlaced = false
		animating = true
		$AudioStreamPlayer2.play()
		await get_tree().create_timer(1.5).timeout
		spin = true
		$AudioStreamPlayer5.play()
		tween = create_tween()
		if gameMode == 1:
			ballSpeed = randf_range (0.5,2.5)
		tween.set_speed_scale(ballSpeed)
		tween.connect("finished", on_tween_finished)
		tween.tween_property($Ball, "position",get_random_target(), 1)


func set_random_start():
	if gameStarted:
		isPlaced = true
		isStarted = true
		## Set Ball To Random Locations
		$Ball.sleeping = true
		await get_tree().create_timer(0.2).timeout
		var cornerPos1 = $KickAreaCorner1.global_position
		var cornerPos2 = $KickAreaCorner2.global_position
		var random_x = randf_range(cornerPos1.x,cornerPos2.x)
		var random_z = randf_range(cornerPos1.z,cornerPos2.z)
		$Ball.global_position.x = random_x
		$Ball.global_position.z = random_z
		$Ball.global_position.y = $Ball/MeshInstance3D.mesh.radius

func on_tween_finished():
	$AudioStreamPlayer4.play()
	misses += 1
	$Misses.text = "Misses: " + str(misses)	
	animating = false
	spin = false
	set_random_start()
	if gameMode == 1:
		await get_tree().create_timer(1.5).timeout
		animate_ball()

func get_random_target():
	var goalPost1 = $GoalPost1.global_position
	var goalPost2 = $GoalPost2.global_position
	var random_y = randf_range(goalPost1.y, goalPost2.y)
	var random_x = randf_range(goalPost1.x, goalPost2.x)
	currTarget = Vector3(random_x, random_y, goalPost1.z)
	return currTarget


func _on_left_controller_button_pressed(name):
#	if name == "by_button":
#		set_random_start()
	if name == "ax_button":
		$SpatialMenu.visible = true
		$XROrigin3D/RightController/StaticBody3D/CollisionShape3D/LaserPointer.visible = true
		gameStarted = false

func _on_right_controller_button_pressed(name):
	if gameMode == 0:
		if name == "by_button":
			if !animating:
				set_random_start()
		if name == "ax_button":		
			if !animating:
				animate_ball()


func _on_button_pressed():
	$SpatialMenu.visible = false
	$XROrigin3D/RightController/StaticBody3D/CollisionShape3D/LaserPointer.visible = false
	gameStarted = true
	if gameMode == 1:
		set_random_start()
		await get_tree().create_timer(1.5).timeout
		animate_ball()
	else:
		ballSpeed = $SpatialMenu/MeshInstance3D/SubViewport/CanvasLayer/HSlider.value

func _on_h_slider_value_changed(value):
	ballSpeed = value


func _on_button_2_pressed():
	score = 0
	misses = 0
	$Saves.text = "Saves: " + str(score)
	$Misses.text = "Misses: " + str(misses)	


func _on_check_button_2_toggled(button_pressed):

	if button_pressed:
		gameMode = 0
	else:
		gameMode = 1

