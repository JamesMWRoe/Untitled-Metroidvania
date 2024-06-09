extends CharacterBody2D

@onready var pendulum_centre = $"../PendulumCentre"

var angular_velocity: float
var length_of_pendulum: float
var angle_to_centre: float
var vector_from_centre: Vector2
var previous_expected_position: Vector2

const TIME_PERIOD = 1
var gravity: float

func _ready() -> void:
	vector_from_centre = pendulum_centre.position - position
	angle_to_centre = atan2(vector_from_centre.x, -vector_from_centre.y)
	length_of_pendulum = vector_from_centre.length()
	
	print(length_of_pendulum)
	angular_velocity = 100 / (length_of_pendulum)
	gravity = 2/length_of_pendulum

func _physics_process(delta) -> void:
	vector_from_centre = pendulum_centre.position - position
	angle_to_centre = atan2(vector_from_centre.x, -vector_from_centre.y)
	
	var angular_acceleration = -gravity * sin(angle_to_centre)
	
	angular_velocity += angular_acceleration
	
	var angle_next_frame = angle_to_centre + (angular_velocity * delta) + (angular_acceleration * delta * delta / 2)
	
	var expected_new_position = Vector2(length_of_pendulum * sin(angle_next_frame), -length_of_pendulum * cos(angle_next_frame))
	var current_velocity = -(expected_new_position - vector_from_centre) / delta
	
	if not previous_expected_position:
		previous_expected_position = expected_new_position
	
	velocity.x = current_velocity.x
	velocity.y = current_velocity.y
	
	#print(rad_to_deg(angle_to_centre))
	#print(rad_to_deg(angle_next_frame))
	#print(angular_acceleration)
	#print(angular_velocity)
	#print()
	#
	#print(previous_expected_position)
	#print(vector_from_centre)
	#print(expected_new_position)
	#print()
	#print()
	previous_expected_position = expected_new_position
	move_and_slide()
