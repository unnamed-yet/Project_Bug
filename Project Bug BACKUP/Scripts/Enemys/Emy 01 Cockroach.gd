extends KinematicBody2D


# Basic Movement Varaiables
var velocity = Vector2()
var move_direction = Vector2()
export(int) var max_speed = 105
export(float) var acceleration = 26.25
export(float) var friction = 52.5
export(float) var attack_speed_multiplyer = 1.25
var x_dir = -1
var prev_x_dir = x_dir
# Timer Varaiables
export(float) var walk_time = 1.5
var walk_timer = walk_time
var nums = [1,0,-1] #list to choose from
# Check varaiables (Mainly for states)
var is_attacking = false
#var is_moveing = false
# For attacking the player (node)
var player_node


func _ready():
	randomize()

func apply_velocity():
	velocity = move_and_slide(velocity)
# For walking
func choose_random_dir():
	return nums[randi() % nums.size()]


# Walking (in  arandom direction)
#-------------------------------------------------
func time_between_walk_timeout():
	get_node("time_between_walk").set_paused(true)
	move_direction.x = choose_random_dir()
	x_dir = move_direction.x
	move_direction.y = choose_random_dir()
	walk_timer = get_node("walk_time").get_wait_time()
	walk()
	get_node("walk_time").start()

func walk():
	while walk_timer > 0:
		velocity = velocity.move_toward(move_direction.normalized() * max_speed, acceleration)
		walk_timer = get_node("walk_time").get_time_left()

func walk_time_timeout():
	while velocity != Vector2(0,0):
		velocity = velocity.move_toward(Vector2(0,0), friction)
	get_node("time_between_walk").set_paused(false)

# Attack (the player)
#-----------------------------------------
func AttackRange_area_entered(_area):
	if _area.is_in_group("Player_hitbox"):
		is_attacking = true
		player_node = _area.get_parent()

func AttackRange_area_exited(_area):
	if _area.is_in_group("Player_hitbox"):
		is_attacking = false
		player_node = null
		while velocity != Vector2(0,0):
			velocity = velocity.move_toward(Vector2(0,0), friction)

func attack():
	if player_node != null:
		move_direction = self.get_global_position().direction_to(player_node.get_global_position()).normalized()
		x_dir = move_direction.round().x
		velocity = velocity.move_toward(move_direction * max_speed * attack_speed_multiplyer, acceleration)
	if player_node == null:
		is_attacking = false


func turning():
	if x_dir != 0 && x_dir != prev_x_dir:
		prev_x_dir = x_dir
		scale.x *= -1

