extends State

@export
var wall_jump: State
@export
var fall: State

var wall_slide_velocity = 20

var direction

func enter() -> void:
	context.velocity.y = wall_slide_velocity

func physics_update(delta) -> void:
	if not context.is_on_wall():
		state_machine.transition_to_state(fall)
		
	direction = Input.get_axis("move_left", "move_right")
	
	if sign(direction) == sign(context.get_wall_normal().x):
		context.velocity.x = direction * 10
	
	if Input.is_action_just_pressed("jump") or context.is_jump_buffered:
		state_machine.transition_to_state(wall_jump)
