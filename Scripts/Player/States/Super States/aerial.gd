extends State
class_name AerialState

@export
var idle: State
@export
var grapple: State

var gravity = context.GRAVITY

func physics_update(delta) -> void:
	super.physics_update(delta)
	
	context.velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		context.buffer_jump()


func _check_for_state_transition() -> void:
	if context.is_on_floor():
		state_machine.transition_to_state(idle)
		return
	
	if Input.is_action_just_pressed("grapple") and context.current_grapple_point != null:
		state_machine.transition_to_state(grapple)
		return
	else:
		context.buffer_grapple()

