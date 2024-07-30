extends AerialState

@export
var fall: State
@export
var wall_slide: State

func physics_update(delta) -> void:
	self.animation_name = "jumping"
	direction = Input.get_axis("move_left", "move_right")
	super(delta)

func _check_for_state_transition() -> void:
	super()
	
	if context.is_on_wall():
		state_machine.transition_to_state(wall_slide)
