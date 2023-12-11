extends StaticBody3D

var xr_origin = null
# Called when the node enters the scene tree for the first time.
func _ready():
	xr_origin = get_node("../XROrigin3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = position.distance_to(xr_origin.position)

	
	if distance < 1:
		var newMaterial = StandardMaterial3D.new() #Make a new Spatial Material
		newMaterial.albedo_color = Color(1, 0, 0, 1) #Set color of new material
		$"MeshInstance3D2".material_override = newMaterial


		
