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
	
	var cornerPos1 = $KickAreaCorner1.position
	var cornerPos2 = $KickAreaCorner2.position
	var random_x = randf_range(cornerPos1.x,cornerPos2.x)
	var random_z = randf_range(cornerPos1.z,cornerPos2.z)
	$Ball.position.x = random_x
	$Ball.position.z = random_z
	$Ball.position.y = $Ball/MeshInstance3D.mesh.radius
	
	
	
