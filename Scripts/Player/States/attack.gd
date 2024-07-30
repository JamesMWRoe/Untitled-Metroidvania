extends State

@export
var idle: State

@onready var attack_timer = $AttackTimer
@onready var hit_box = $"../../Attack"

func enter() -> void:
	super()
	context.velocity = Vector2.ZERO
	attack_timer.start()
	hit_box.attack_activate()


func _on_attack_timer_timeout():
	hit_box.attack_deactivate()
	state_machine.transition_to_state(idle)
