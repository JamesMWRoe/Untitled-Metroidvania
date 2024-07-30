extends AerialState

@export
var fall: State


func enter() -> void:
	self.animation_name = "jumping"
	super()
	context.velocity.y += context.JUMP_VELOCITY
	if not Input.is_action_pressed("jump"):
		context.velocity.y /= 3
	

func physics_update(delta):
	
	direction = Input.get_axis("move_left", "move_right")
	context.velocity.x = direction * context.MAX_RUN_SPEED
	
	if Input.is_action_just_released("jump"):
		context.velocity.y /= 3
	
	
	
	super(delta)

func _check_for_state_transition() -> void:
	super()
	
	if context.velocity.y > 0:
		state_machine.transition_to_state(fall)

