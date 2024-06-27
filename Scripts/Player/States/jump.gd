extends State

@export
var fall: State

func enter() -> void:
	context.velocity.y += context.JUMP_VELOCITY

func physics_update(delta):
	
	_check_for_transition()
	
	context.velocity.y += context.GRAVITY
	
	if Input.is_action_just_released("jump"):
		context.velocity.y /= 3

func _check_for_transition() -> void:
	if context.velocity.y < 0:
		state_machine.transition_to_state(fall)
