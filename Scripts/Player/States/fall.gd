extends State

@export
var idle: State

func physics_update(delta):
	context.velocity.y += context.GRAVITY
	
	if Input.is_action_just_pressed("jump"):
		context.buffer_jump()

func _check_for_transition() -> void:
	if context.is_on_floor():
		state_machine.transition_to_state(idle)
