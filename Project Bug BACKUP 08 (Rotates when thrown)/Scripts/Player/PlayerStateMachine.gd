extends StateMachine

# Animation varaiables (Speeds)
export(float) var run_anim_speed = 6

func _ready():
	add_state("idle")
	add_state("run")
	add_state("attack")
	call_deferred("set_state", states.idle)

func state_logic(delta):
	parent.movement(delta)
	parent.apply_velocity()
	parent.turning()

func get_transition(delta):
	match state:
		states.idle:
			if parent.is_moveing:
				return states.run
			elif parent.is_attacking:
				return states.attack
		states.run:
			if !parent.is_moveing:
				return states.idle
			elif parent.is_attacking:
				return states.attack
		states.attack:
			if !parent.is_attacking && !parent.is_moveing:
				return states.idle
			elif !parent.is_attacking && parent.is_moveing:
				return states.run
	return null

func enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.get_node("CharacterSprite/AnimationPlayer").play("idle", -1, 1.5)
		states.run:
			parent.get_node("CharacterSprite/AnimationPlayer").play("run", -1, run_anim_speed)
		states.attack:
			parent.get_node("CharacterSprite/AnimationPlayer").play("idle", -1, 1.5)

func exit_state(old_state, new_state):
	pass
