extends KinematicBody2D

# Damage
export(float) var damage = 5
# Where to move varaiables
# ------------------------
onready var parent = get_parent()
var move_dir = Vector2(0,0)
var move_to_pos = Vector2(0,0)
export(float) var max_distance_point = 20 # Maximum distance from move_to_pos
# ------------------------
var velocity = Vector2(0,0)
export(int) var max_speed = 200
export(int) onready var friction = 2 * max_speed
export(int) var acceleration = 30
var pos = Vector2(0,0)
# Rotation varaiables
# -------------------
export(float) var smooth_spd = 0.4
export(float) var rotate_speed = 0.5
export(float) var center_dis = 40 # In pixels
export(float) var max_rand_rotation = 1.3
var rand_rotation
# Varaibles for states
# --------------------
var is_moveing = true
var has_landed = false


func apply_velocity():
	velocity = move_and_slide(velocity)

func rotate_toward_mouse():
	rotation += get_local_mouse_position().angle() * smooth_spd


# Setting up the position it'll be moveing toward 
# and sets "has_landed" for states 
func setup_throw():
	move_to_pos = get_global_mouse_position()
	move_dir = (get_global_mouse_position() - global_position).normalized()
	pos = global_position
	has_landed = false


func rotate_when_thrown():
	rotation += rotate_speed
func move_to_throw_pos():
	# Move if not at the cursor's remembered position
	# Else stop
	if global_position.distance_to(move_to_pos) >= max_distance_point:
		pos += move_dir * acceleration
	else:
		velocity = velocity.move_toward(Vector2(0,0), friction)
		if velocity == Vector2(0,0):
			has_landed = true
	
	global_position = pos
	rotate_when_thrown()


# stay in position when LANDED
func setup_stay_at_pos():
	move_to_pos = global_position
func stay_at_pos():
	global_position = move_to_pos

func set_random_rotation():
	rand_rotation = rand_range(max_rand_rotation, PI - max_rand_rotation)

func rotate_to_face_ground():
	if rotation < 0 && round(rotation) != round(rand_rotation):
		rotation += rotate_speed


func just_landed_effect():
	# particles, no damage
	pass
func landed_effect():
	# particles, if enemy enters an area then damage
	pass


func rotate_when_back_to_center():
	rotation -= rotate_speed
func back_to_center():
	if global_position.distance_to(get_target()) >= max_distance_point / 4:
#	if global_position != get_target():
		move_dir = (get_target() - global_position).normalized()
		pos += move_dir * acceleration
	else:
		# If i don't teleport it to the target, it might go back and forth 
		# towards the point, because it takes too big steps, 
		# but it's barely visible in my opinion
		pos = get_target()
	
	global_position = pos
	rotate_when_back_to_center()

func get_target(): # The target is the position wich I want to have it in the idle state
	return parent.global_position + Vector2(center_dis, 0)



func SwordHitbox_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		if $SwordSpeed.speed != 0:
			area.get_parent().take_damage(damage + round(damage * $SwordSpeed.speed))

