extends GroundedState

@export
var idle: State

var direction

func enter() -> void:
	self.animation_name = "running"
	super()

func physics_update(delta):
	direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		context.is_facing_right = false
	elif direction > 0:
		context.is_facing_right = true
	
	context.velocity.x = direction * context.MAX_RUN_SPEED
	
	super(delta)

func _check_for_state_transition() -> void:
	super()
	
	if direction == 0:
		state_machine.transition_to_state(idle)
