extends State

@export
var move: State
@export
var jump: State
@export
var fall: State

func update(delta) -> void:
	check_for_transition_state()

func check_for_transition_state() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		state_machine.transition_to_state(move)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to_state(jump)
	
	if not context.is_on_floor():
		state_machine.transition_to_state(fall)
