extends GrappleState

@export
var grapple: State        
@export
var fall: State
@export
var idle: State

func enter() -> void:
	self.animation_name = "falling"
	grapple_renderer.current_grapple_state = grapple_renderer.GRAPPLE_STATE.EXTENDING
	super()

func physics_update(delta) -> void:
	context.velocity.y += context.GRAVITY * delta 
	var new_vector_to_grapple_point = vector_to_grapple_point - (context.velocity * delta)
	if new_vector_to_grapple_point.length() >= length_of_grapple_rope:
		#bad calculations, need to be fixed so rope length is more accurate
		var length_to_rope_max = length_of_grapple_rope - vector_to_grapple_point.length()
		var direction_of_velocity = context.velocity.normalized()
		context.position += direction_of_velocity * length_to_rope_max 
		
		state_machine.transition_to_state(grapple)
	
	super(delta)

func exit() -> void:
	super()
	grapple_renderer.current_grapple_state = grapple_renderer.GRAPPLE_STATE.NULL

func _check_for_state_transition() -> void:
	super()
	
	if Input.is_action_just_released("grapple"):
		state_machine.transition_to_state(fall)
	
	if context.is_on_floor():
		state_machine.transition_to_state(idle)
