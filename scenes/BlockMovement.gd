extends StaticBody3D

var amplitude = 4
var speed = 2
var time_accumulator = 0
var xr_origin = null
# Called when the node enters the scene tree for the first time.
func _ready():
	xr_origin = get_node("../XROrigin3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	time_accumulator += delta

	var offset = amplitude * sin(speed * time_accumulator)
	position.x = offset
	
	var distance = position.distance_to(xr_origin.position)
	#print(distance)
	
	if abs(distance) < 1:
		print("here")
		xr_origin.global_transform.origin = Vector3(0, 0, 0)
	
