extends CharacterBody2D
class_name Player

@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var grapple_buffer_timer: Timer = $Timers/GrappleBufferTimer
@onready var state_machine: StateMachine = $StateMachine

@onready var grapple_point_detector = $GrappleDetector
@onready var grapple_line = $GrappleLine

const TILE_UNIT = 16

const MAX_RUN_SPEED = 4 * TILE_UNIT
const MAX_GRAPPLE_SPEED = 12 * TILE_UNIT
const JUMP_HEIGHT = 2.5 * TILE_UNIT
const JUMP_DISTANCE = 2 * TILE_UNIT

const MAX_GRAPPLE_LENGTH = 65

const JUMP_VELOCITY = -2 * JUMP_HEIGHT * MAX_RUN_SPEED / JUMP_DISTANCE
const GRAVITY = 2 * JUMP_HEIGHT * (MAX_RUN_SPEED*MAX_RUN_SPEED) / (JUMP_DISTANCE*JUMP_DISTANCE)
const ACCELERATION = 4 * TILE_UNIT

var is_jump_buffered = false
var is_within_coyote_time = false

var is_grapple_buffered = false

var current_grapple_point: GrapplePoint
var is_grappling: bool = false

var vector_to_grapple_point: Vector2
var angle_from_grapple_point: float
var length_to_grapple_point: float

var angular_velocity: float
var grapple_limiting_factor: float = 0.1

func _ready():
	state_machine.init(self)

func _physics_process(delta):
	move_and_slide()

func buffer_jump() -> void:
	jump_buffer_timer.start()
	is_jump_buffered = true

func buffer_grapple() -> void:
	grapple_buffer_timer.start()
	is_grapple_buffered = true

func reset_coyote_time() -> void:
	coyote_timer.start()
	is_within_coyote_time = true

func set_grapple_point(grapple_point):
	current_grapple_point = grapple_point

func disengage_grapple_point():
	current_grapple_point = null
	is_grappling = false

func _on_jump_buffer_timer_timeout():
	is_jump_buffered = false

func _on_coyote_timer_timeout():
	is_within_coyote_time = false

func _on_grapple_buffer_timer_timeout():
	is_grapple_buffered = false
