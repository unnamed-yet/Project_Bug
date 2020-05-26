extends StateMachine

var prev_state

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("attack") # Attacking the (a) player
	call_deferred("set_state", states.idle)

func state_logic(_delta):
	parent.apply_velocity()
	match state:
		states.idle:
			if prev_state != states.idle:
				parent.get_node("time_between_walk").set_paused(false)
				parent.get_node("time_between_walk").start()
		states.walk:
			parent.turning()
		states.attack:
			if prev_state != states.attack:
				parent.get_node("time_between_walk").set_paused(true)
				parent.get_node("time_between_walk").stop()
			parent.attack()
			parent.turning()
			
	prev_state = state


func get_transition(_delta):
	match state:
		states.idle:
			if parent.velocity != Vector2(0,0) && !parent.is_attacking:
				return states.walk
			elif parent.is_attacking:
				return states.attack
		states.walk:
			if parent.velocity == Vector2(0,0):
				return states.idle
			elif parent.is_attacking:
				return states.attack
		states.attack:
			if !parent.is_attacking:
				return states.idle

func enter_state(_new_state, _old_state):
	match _new_state:
		states.idle:
			parent.get_node("Sprite/AnimationPlayer").play("idle")
		states.walk:
			parent.get_node("Sprite/AnimationPlayer").play("walk")
		# There is no attack animation yet !
		#---------------------------------
		states.attack:
			parent.get_node("Sprite/AnimationPlayer").play("walk")
