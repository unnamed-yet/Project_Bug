extends KinematicBody2D

# Basic Movement6 varaiables
var velocity = Vector2(0,0)
export(int) var acceleration = 60
export(int) var friction = 240
export(int) var max_speed = 480
var move_direction = Vector2()
var x_dir = 1
var prev_x_dir = x_dir
# Check varaiables (mainly for states)
var is_moveing
var is_attacking


func apply_velocity():
	velocity = move_and_slide(velocity)

# warning-ignore:unused_argument
func movement(delta):
	move_direction.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	x_dir = move_direction.x
	move_direction.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))
	move_direction = move_direction.normalized()
	is_moveing = move_direction != Vector2(0,0)
	
	# If move-input (direction) change velocity
	if is_moveing: 
		velocity += acceleration * move_direction
		velocity = velocity.clamped(max_speed)
	else:
		velocity =  velocity.move_toward(Vector2(0,0), friction)


func turning():
	if x_dir != 0 && x_dir != prev_x_dir:
		prev_x_dir = x_dir
		scale.x *= -1

func call_attack():
	if Input.is_action_just_pressed("ui_attack"):
		is_attacking = true
	elif Input.is_action_just_released("ui_attack"):
		is_attacking = false
