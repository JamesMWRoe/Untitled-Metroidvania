extends State

@export
var idle: State

@onready
var attack_timer = $AttackTimer
var hit_box

func enter() -> void:
	attack_timer.start()
	
func physics_update(delta) -> void:
	pass
