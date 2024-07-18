extends GroundedState

@export
var move: State

func enter() -> void:
	context.velocity.x = 0
	context.velocity.y = 0

func physics_update(delta) -> void:
	super(delta)

func _check_for_state_transition() -> void:
	super()
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.transition_to_state(move)
