extends AerialState

@export
var wall_slide: State

var direction

func physics_update(delta):
	super.physics_update(delta)
	
	direction = Input.get_axis("move_left", "move_right")
	context.velocity.x = direction * context.MAX_RUN_SPEED
	
	if context.is_on_wall():
		state_machine.transition_to_state(wall_slide)
