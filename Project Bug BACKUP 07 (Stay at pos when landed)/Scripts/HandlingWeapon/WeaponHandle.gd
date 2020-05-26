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
export(float) var center_dis = 40 # In pixels
# Varaibles for states
# --------------------
var is_moveing = true
var has_landed = false

#func _ready():
#	global_position = get_target()

func apply_velocity():
	velocity = move_and_slide(velocity)

# Setting up the position it'll be moveing toward 
# and sets "has_landed" for states 
func setup_throw():
	move_to_pos = get_global_mouse_position()
	move_dir = (get_global_mouse_position() - global_position).normalized()
	pos = global_position
	has_landed = false


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


func setup_stay_at_pos():
	move_to_pos = global_position
func stay_at_pos():
	global_position = move_to_pos


func just_landed_effect():
	# particles, no damage
	pass

func landed_effect():
	# particles, if enemy enters an area then damage
	pass

func back_to_center():
	if global_position.distance_to(get_target()) >= max_distance_point / 2:
#	if global_position != get_target():
		move_dir = (get_target() - global_position).normalized()
		pos += move_dir * acceleration
	
	global_position = pos

func get_target(): # The target is the position wich I want to have it in the idle state
	return parent.global_position + Vector2(center_dis, 0)

func rotate_toward_mouse():
	rotation += get_local_mouse_position().angle() * smooth_spd



func SwordHitbox_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		if $SwordSpeed.speed != 0:
			area.get_parent().take_damage(damage + round(damage * $SwordSpeed.speed))

