extends State

@export
var wall_jump: State
@export
var fall: State

@onready
var exit_buffer_timer: Timer = $BufferTimer

var wall_slide_velocity = 20

var direction

func enter() -> void:
	context.velocity.y = wall_slide_velocity

func physics_update(delta) -> void:
	super(delta)
	
	direction = Input.get_axis("move_left", "move_right")
	
	if sign(direction) == sign(context.get_wall_normal().x) and exit_buffer_timer.is_stopped():
		exit_buffer_timer.start()

func _check_for_state_transition() -> void:
	if not context.is_on_wall():
		state_machine.transition_to_state(fall)
	
	if Input.is_action_just_pressed("jump") or context.is_jump_buffered:
		state_machine.transition_to_state(wall_jump)


func _on_buffer_timer_timeout():
	state_machine.transition_to_state(fall)
