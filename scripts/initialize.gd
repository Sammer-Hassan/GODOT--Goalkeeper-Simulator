extends Node3D

var xr_interface: XRInterface

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
	

	
	var tween = create_tween()
	
	tween.tween_property($Ball, "position",getRandomPositions(), 1 )
	

#Returns random goal position for target
func getRandomPositions():
	## Set Ball To Random Location
	var cornerPos1 = $KickAreaCorner1.position
	var cornerPos2 = $KickAreaCorner2.position
	var random_x = randf_range(cornerPos1.x,cornerPos2.x)
	var random_z = randf_range(cornerPos1.z,cornerPos2.z)
	$Ball.position.x = random_x
	$Ball.position.z = random_z
	$Ball.position.y = $Ball/MeshInstance3D.mesh.radius
	## Get Random GoalLine Point
	var goalPost1 = $GoalPost1.position
	var goalPost2 = $GoalPost2.position
	var random_y = randf_range(goalPost1.y, goalPost2.y)
	random_x = randf_range(goalPost1.x, goalPost2.x)
	
	return Vector3(random_x, random_y, goalPost1.z)

	
	
	

	
	
	
	
	
