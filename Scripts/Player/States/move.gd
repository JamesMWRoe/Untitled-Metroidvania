extends GroundedState

@export
var idle: State

var direction

func physics_update(delta):
	super.physics_update(delta)
	
	_check_for_transition()
	
	direction = Input.get_axis("move_left", "move_right")
	
	context.velocity.x = direction * context.MAX_RUN_SPEED
	

func _check_for_transition() -> void:
	if direction == 0:
		state_machine.transition_to_state(idle)
