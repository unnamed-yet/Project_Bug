extends Position2D

export(float) var smooth_speed = 0.4

func _physics_process(delta):
	pass
#	rotate_if_weaponhandle_attached()

func rotate_if_weaponhandle_attached():
	if has_node("WeaponHandle"):
		rotation += get_local_mouse_position().angle() * smooth_speed
