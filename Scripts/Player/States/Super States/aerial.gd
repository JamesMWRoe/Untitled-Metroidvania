extends State
class_name AerialState

@export
var idle: State

var gravity = context.GRAVITY

func update(delta) -> void:
	super.update(delta)
	
	if Input.is_action_just_pressed("jump"):
		context.buffer_jump()

func physics_update(delta) -> void:
	context.velocity.y += gravity * delta
	
	check_for_transition_state()

func check_for_transition_state() -> void:
	if context.is_on_floor():
		state_machine.transition_to_state(idle)
	
	

