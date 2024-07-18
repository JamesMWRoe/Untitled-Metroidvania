extends Node
class_name State

var context: Player
var state_machine: StateMachine

@export var is_active: bool = true

func enter() -> void:
	pass

func update(delta) -> void:
	pass

func physics_update(delta) -> void:
	_check_for_state_transition()

func exit() -> void:
	pass

func _check_for_state_transition() -> void:
	pass
