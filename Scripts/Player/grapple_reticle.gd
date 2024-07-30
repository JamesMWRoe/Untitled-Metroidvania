extends Node2D

@onready var player = $"../.."

func _physics_process(delta) -> void:
	if player.current_grapple_point == null:
		hide()
		return
	
	show()
	_update_position_and_rotation(delta)

func _update_position_and_rotation(delta) -> void:
	position = player.current_grapple_point.position - player.position
	rotate(2 * delta)
