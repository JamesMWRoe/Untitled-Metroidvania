extends CharacterBody2D
class_name Player

@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var state_machine: StateMachine = $StateMachine

const TILE_UNIT = 16

const MAX_RUN_SPEED = 4 * TILE_UNIT
const MAX_GRAPPLE_SPEED = 12 * TILE_UNIT
const JUMP_HEIGHT = 2.5 * TILE_UNIT
const JUMP_DISTANCE = 2 * TILE_UNIT

const JUMP_VELOCITY = -2 * JUMP_HEIGHT * MAX_RUN_SPEED / JUMP_DISTANCE
const GRAVITY = 2 * JUMP_HEIGHT * (MAX_RUN_SPEED*MAX_RUN_SPEED) / (JUMP_DISTANCE*JUMP_DISTANCE)
const ACCELERATION = 4 * TILE_UNIT

var is_jump_buffered = false
var is_within_coyote_time = false

@export var current_grapple_point: Node2D
var is_grapple_setup: bool = false
var is_grappling: bool = false

var vector_to_grapple_point: Vector2
var angle_from_grapple_point: float
var length_to_grapple_point: float

var gravity: float
var angular_velocity: float
var grapple_limiting_factor: float = 0.1

func _ready():
	state_machine.init(self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		coyote_timer.start()
		is_within_coyote_time = true
	
	
	# Handle jump.

	
	if is_jump_buffered and is_within_coyote_time:
		is_jump_buffered = false
		is_within_coyote_time = false
		velocity.y = JUMP_VELOCITY
	
	
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 3
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("grapple") and current_grapple_point:
		is_grappling = true
		
		vector_to_grapple_point = current_grapple_point.position - position
		angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)
		length_to_grapple_point = vector_to_grapple_point.length()
		
		var tangent_to_pendulum = Vector2(cos(angle_from_grapple_point), -sin(angle_from_grapple_point))
		gravity = 2/length_to_grapple_point
		angular_velocity = -velocity.project(tangent_to_pendulum).length() * delta 
	
	if Input.is_action_just_released("grapple"):
		is_grappling = false
	
	if is_grappling:
		vector_to_grapple_point = current_grapple_point.position - position
		angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)
		
		var angular_acceleration = (-GRAVITY * delta * sin(angle_from_grapple_point) / length_to_grapple_point)
		
		
		if sign(angle_from_grapple_point) != sign(angular_velocity):
			angular_acceleration *= (0.9 - (0.2*direction*sign(angular_velocity)))
		
		angular_velocity += angular_acceleration
		
		
		#angular_velocity = clampf(angular_velocity, -2, 2)
		
		var angle_next_frame = angle_from_grapple_point + (angular_velocity * delta) + (angular_acceleration * delta * delta / 2)
		
		var expected_new_position = Vector2(length_to_grapple_point * sin(angle_next_frame), -length_to_grapple_point * cos(angle_next_frame))
		var current_velocity = -(expected_new_position - vector_to_grapple_point) / delta
		
		if abs(angular_velocity) <= 0.01:
			print('max angle: ')
			print(rad_to_deg(angle_from_grapple_point))
			print('length of pendulum')
			print(length_to_grapple_point)
			print('max angular acceleration')
			print(angular_acceleration)
			print()
		
		if abs(angular_acceleration) < 0.01:
			print('max angular velocity: ')
			print(angular_velocity)
			print('max velocity:')
			print(current_velocity)
			print()
		
		velocity = current_velocity
	
	move_and_slide()

func buffer_jump() -> void:
	jump_buffer_timer.start()
	is_jump_buffered = true

func set_grapple_point(grapple_point):
	current_grapple_point = grapple_point

func disengage_grapple_point():
	current_grapple_point = null
	is_grappling = false

func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func _on_coyote_timer_timeout():
	is_within_coyote_time = false
