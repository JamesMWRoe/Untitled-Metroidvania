extends Node2D
class_name RenderStateMachine

@export
var initial_state: RenderState

@onready var context = $".."

var current_state: RenderState

func init(context: Player) -> void:
	for child in get_children():
		child.context = context
		child.state_machine = self
	
	transition_to_state(initial_state)

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)
	queue_redraw()

func _draw():
	if current_state:
		current_state.render()

func transition_to_state(new_state: RenderState) -> void:
	if not new_state.is_active:
		return
	
	if current_state:
		current_state.exit()
	
	print(new_state)
	
	current_state = new_state
	
	new_state.enter()
