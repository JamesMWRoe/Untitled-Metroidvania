extends GrappleState

@export
var grapple: State        
@export
var fall: State

signal state_begun
signal state_ended

func enter() -> void:
	super()
	
	state_begun.emit()

func physics_update(delta) -> void:
	super(delta)
	
	context.velocity.y += context.GRAVITY * delta 
	var new_vector_to_grapple_point = vector_to_grapple_point - (context.velocity * delta)
	if new_vector_to_grapple_point.length() >= length_of_grapple_rope:
		#bad calculations, need to be fixed so rope length is more accurate
		var length_to_rope_max = length_of_grapple_rope - vector_to_grapple_point.length()
		var direction_of_velocity = context.velocity.normalized()
		print(vector_to_grapple_point.length())
		print(length_to_rope_max)
		print(context.position)
		print((direction_of_velocity * length_to_rope_max).length())
		context.position += direction_of_velocity * length_to_rope_max
		print(context.position)
		print((context.current_grapple_point.position - context.position).length()    )
		state_machine.transition_to_state(grapple)

func exit() -> void:
	super()
	state_ended.emit()

func _check_for_state_transition() -> void:
	super()
	
	if Input.is_action_just_released("grapple"):
		state_machine.transition_to_state(fall)
