extends StateMachine

func _ready():
	add_state("in_hand")
#	add_state("throwing")
	add_state("thrown")
	add_state("moveing")
	add_state("landed")
	add_state("call_back_prepare")
	add_state("call_back")
	call_deferred("set_state", states.in_hand)


func state_logic(_delta):
	parent.apply_velocity()
	match state:
		states.in_hand:
			parent.rotate_toward_mouse()
		states.thrown:
			parent.setup_throw()
		states.moveing:
			parent.move_to_throw_pos()
		states.landed:
			parent.reset_throw()
		states.call_back_prepare:
			pass
		states.call_back:
			parent.back_to_center()


func get_transition(_delta):
	match state:
		states.in_hand:
			if Input.is_action_just_pressed("ui_attack"):
				return states.thrown
		states.thrown:
			return states.moveing
		states.moveing:
			if parent.has_landed:
				return states.landed
		states.landed:
			if Input.is_action_just_pressed("ui_attack"):
				return states.call_back_prepare
		states.call_back_prepare:
			return states.call_back
		states.call_back:
			if parent.global_position == parent.get_target():
				return states.in_hand
	return null

func enter_state(_new_state, _old_state):
	pass

func exit_state(_old_state, _new_state):
	pass
