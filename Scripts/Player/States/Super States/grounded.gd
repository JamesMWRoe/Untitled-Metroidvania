extends State
class_name GroundedState

@export
var jump: State
@export
var fall: State

func physics_update(delta) -> void:
	check_for_transition()
	context.reset_coyote_time()

func check_for_transition() -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to_state(jump)
	
	if not context.is_on_floor():
		state_machine.transition_to_state(fall)
