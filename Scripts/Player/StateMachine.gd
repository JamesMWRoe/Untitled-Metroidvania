extends Node
class_name StateMachine

@export
var initial_state: State

var current_state: State


func init(context: Player) -> void:
	for child in get_children():
		child.context = context
		child.state_machine = self
	
	transition_to_state(initial_state)

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)


func transition_to_state(new_state: State):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	new_state.enter()
