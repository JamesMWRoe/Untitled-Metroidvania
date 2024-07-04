extends AerialState

@export
var fall: State

@onready var wall_jump_timer: Timer = $WallJumpTimer

func enter() -> void:
	context.velocity.y += context.JUMP_VELOCITY
	var jump_direction = sign(context.get_wall_normal().x)
	context.velocity.x = jump_direction * 50
	
	wall_jump_timer.start()

func physics_update(delta):
	super.physics_update(delta)
	
	if Input.is_action_just_released("jump"):
		context.velocity.y /= 3

func _on_wall_jump_timer_timeout():
	state_machine.transition_to_state(fall)
