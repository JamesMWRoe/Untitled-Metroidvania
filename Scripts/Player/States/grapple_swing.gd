extends GrappleState

@export
var grapple_jump: State
@export
var idle: State

var direction: float

var angular_velocity: float

func enter() -> void:
	super()
	
	_draw_grapple_line()
	
	var tangent_to_pendulum = Vector2(cos(angle_from_grapple_point), -sin(angle_from_grapple_point))
	print(vector_to_grapple_point.length())
	angular_velocity = -sign(angle_from_grapple_point)*context.velocity.project(tangent_to_pendulum).length() * get_physics_process_delta_time()
	context.velocity = Vector2.ZERO

func physics_update(delta) -> void:
	super(delta)
	_redraw_grapple_line()
	
	_handle_collisions(delta)
	_grapple_move(delta)

func exit() -> void:
	_remove_grapple_line()

func _check_for_state_transition() -> void:
	if Input.is_action_just_released("grapple"):
		state_machine.transition_to_state(grapple_jump)
	
	if context.is_on_floor():
		state_machine.transition_to_state(idle)


func _grapple_move(delta) -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	var angular_acceleration = (-context.GRAVITY * delta * sin(angle_from_grapple_point) / length_to_grapple_point)
	
	if sign(angle_from_grapple_point) != sign(angular_velocity):
		if not direction:
			angular_acceleration *= 0.5
		else:
			angular_acceleration *= (1 - (0.5*direction*sign(angular_velocity)))
	
	angular_velocity += angular_acceleration
	
	#angular_velocity = clampf(angular_velocity, -2, 2)
	
	var angle_next_frame = angle_from_grapple_point + (angular_velocity * delta) + (angular_acceleration * delta * delta / 2)
	
	var expected_new_position = Vector2(length_to_grapple_point * sin(angle_next_frame), -length_to_grapple_point * cos(angle_next_frame))
	var current_velocity = -(expected_new_position - vector_to_grapple_point) / delta
	
	context.velocity = current_velocity

func _handle_collisions(delta) -> void:
	if context.is_on_wall():
		angular_velocity *= -0.3
	
	if context.is_on_ceiling():
		angular_velocity *= -0.3


