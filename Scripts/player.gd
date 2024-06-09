extends CharacterBody2D

@onready var jump_buffer_timer: Timer = $JumpBufferTimer
const TILE_UNIT = 16

const MAX_RUN_SPEED = 4 * TILE_UNIT
const MAX_GRAPPLE_SPEED = 12 * TILE_UNIT
const JUMP_HEIGHT = 1.5 * TILE_UNIT
const JUMP_DISTANCE = 2 * TILE_UNIT

const JUMP_VELOCITY = -2 * JUMP_HEIGHT * MAX_RUN_SPEED / JUMP_DISTANCE
const GRAVITY = 2 * JUMP_HEIGHT * (MAX_RUN_SPEED*MAX_RUN_SPEED) / (JUMP_DISTANCE*JUMP_DISTANCE)
const ACCELERATION = 4 * TILE_UNIT

var is_jump_buffered = false

@export var current_grapple_point: Node2D
var is_grapple_setup: bool = false
var is_grappling: bool = false

var vector_to_grapple_point: Vector2
var angle_from_grapple_point: float
var length_to_grapple_point: float

var gravity: float
var angular_velocity: float


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
		is_jump_buffered = true
	
	if is_jump_buffered and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 3
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		velocity.x = direction * MAX_RUN_SPEED
		velocity.x = clampf(velocity.x, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	
	if Input.is_action_just_pressed("grapple") and current_grapple_point:
		is_grappling = true
		
		vector_to_grapple_point = current_grapple_point.position - position
		angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)
		length_to_grapple_point = vector_to_grapple_point.length()
		
		gravity = 2/length_to_grapple_point
		angular_velocity = -1.5*velocity.x * delta
	
	if Input.is_action_just_released("grapple"):
		is_grappling = false
	
	if is_grappling:
		vector_to_grapple_point = current_grapple_point.position - position
		angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)
		
		var angular_acceleration = -gravity * sin(angle_from_grapple_point)
		
		angular_velocity += angular_acceleration
		
		var angle_next_frame = angle_from_grapple_point + (angular_velocity * delta) + (angular_acceleration * delta * delta / 2)
		
		var expected_new_position = Vector2(length_to_grapple_point * sin(angle_next_frame), -length_to_grapple_point * cos(angle_next_frame))
		var current_velocity = -(expected_new_position - vector_to_grapple_point) / delta
		
		velocity = current_velocity
	
	move_and_slide()



func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func set_grapple_point(grapple_point):
	current_grapple_point = grapple_point

func disengage_grapple_point():
	current_grapple_point = null
	is_grappling = false
