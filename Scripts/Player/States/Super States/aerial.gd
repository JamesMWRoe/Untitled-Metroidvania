extends State
class_name AerialState

@export
var idle: State
@export
var grapple: State

var direction

var gravity = context.GRAVITY

func physics_update(delta) -> void:
	super.physics_update(delta)
	
	if direction < 0:
		context.is_facing_right = false
	elif direction > 0:
		context.is_facing_right = true
	
	context.velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		context.buffer_jump()
	
	if Input.is_action_just_pressed("grapple"):
		context.buffer_grapple()


func _check_for_state_transition() -> void:
	if context.is_on_floor():
		state_machine.transition_to_state(idle)
		return
	
	if context.is_grapple_buffered and context.current_grapple_point != null:
		state_machine.transition_to_state(grapple)
		return

