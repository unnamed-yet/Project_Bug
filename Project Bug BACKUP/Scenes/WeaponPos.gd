extends Position2D

func _process(_delta):
	rotation += get_local_mouse_position().angle()
