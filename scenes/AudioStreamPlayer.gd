extends AudioStreamPlayer

var play = false

func _ready():
	stream_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stream_paused = play
		


func _on_check_button_toggled(button_pressed):
	print(button_pressed)
	play = !button_pressed
