extends AerialState

@export
var wall_slide: State

func enter() -> void:
	self.animation_name = "falling"
	super()

func physics_update(delta):
	
	direction = Input.get_axis("move_left", "move_right")
	context.velocity.x = direction * context.MAX_RUN_SPEED
	
	super(delta)

func _check_for_state_transition() -> void:
	super()
	
	if context.is_on_wall() and direction == -context.get_wall_normal().x:
		state_machine.transition_to_state(wall_slide)
