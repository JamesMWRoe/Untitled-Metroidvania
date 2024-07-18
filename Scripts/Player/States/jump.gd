extends AerialState

@export
var fall: State

var direction

func enter() -> void:
	context.velocity.y += context.JUMP_VELOCITY

func physics_update(delta):
	super(delta)
	
	direction = Input.get_axis("move_left", "move_right")
	context.velocity.x = direction * context.MAX_RUN_SPEED
	
	if Input.is_action_just_released("jump"):
		context.velocity.y /= 3

func _check_for_state_transition() -> void:
	super()
	
	if context.velocity.y > 0:
		state_machine.transition_to_state(fall)

