extends State
class_name GroundedState

@export
var jump: State
@export
var fall: State
@export
var attack: State

func physics_update(delta) -> void:
	super(delta)
	context.reset_coyote_time()
	
	if Input.is_action_just_pressed("jump"):
		context.buffer_jump()

func _check_for_state_transition() -> void:
	if context.is_jump_buffered:
		state_machine.transition_to_state(jump)
		return
	
	if not context.is_on_floor():
		state_machine.transition_to_state(fall)
		return
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to_state(attack)
		return
