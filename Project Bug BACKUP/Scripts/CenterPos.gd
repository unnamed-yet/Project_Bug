extends Position2D

var mouse_pos

func _process(_delta):
	mouse_pos = get_local_mouse_position()
	rotation += mouse_pos.angle()
	
