extends GrappleState

@export
var grapple_swing: State
@export
var fall: State

var direction: float
func enter() -> void:
	super()
	
	grapple_renderer.current_grapple_state = grapple_renderer.GRAPPLE_STATE.EXTENDED
	
	context.velocity = Vector2.ZERO
	context.position = context.current_grapple_point.position + (Vector2.DOWN*length_of_grapple_rope - Vector2(0,0.1))

func physics_update(delta) -> void:
	if not context.velocity == Vector2.ZERO and direction == 0:
		context.velocity = Vector2.ZERO
		context.position = context.current_grapple_point.position + Vector2.DOWN*length_of_grapple_rope
	
	direction = Input.get_axis("move_left", "move_right")
	
	if not direction == 0:
		context.velocity = 25 * direction * Vector2.RIGHT
		
		print('velocity: ')
		print(context.velocity)
		
		state_machine.transition_to_state(grapple_swing)
		return
	
	if Input.is_action_just_released("grapple"):
		state_machine.transition_to_state(fall)

func exit() -> void:
	super()
	
	grapple_renderer.current_grapple_state = grapple_renderer.GRAPPLE_STATE.NULL
