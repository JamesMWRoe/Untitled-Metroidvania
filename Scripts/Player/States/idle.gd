extends GroundedState

@export
var move: State

func enter() -> void:
	context.velocity.x = 0

func physics_update(delta) -> void:
	super.physics_update(delta)
	check_for_transition_state()

func check_for_transition_state() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		state_machine.transition_to_state(move)
