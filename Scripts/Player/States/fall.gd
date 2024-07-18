extends AerialState

@export
var wall_slide: State

var direction

func physics_update(delta):
	super(delta)
	
	direction = Input.get_axis("move_left", "move_right")
	context.velocity.x = direction * context.MAX_RUN_SPEED

func _check_for_state_transition() -> void:
	super()
	
	if context.is_on_wall() and direction == -context.get_wall_normal().x:
		state_machine.transition_to_state(wall_slide)
