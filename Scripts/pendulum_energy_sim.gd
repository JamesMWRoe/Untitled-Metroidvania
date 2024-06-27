extends CharacterBody2D

@onready var pendulum_centre = $"../PendulumCentre"

var energy_in_system: float
var initial_speed: float
var pendulum_radius: float
var min_pendulum_height: float

var current_kinetic_energy: float
var current_potential_energy: float
var current_speed: float

var current_velocity: Vector2

var direction_of_pendulum = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_speed = 101
	pendulum_radius = position.distance_to(pendulum_centre.position)
	min_pendulum_height = pendulum_centre.position.y + pendulum_radius
	
	var initial_kinetic_energy = initial_speed*initial_speed / 2
	var initial_potential_energy = 200 * (min_pendulum_height - position.y)
	
	energy_in_system = initial_kinetic_energy + initial_potential_energy
	
	#print(initial_kinetic_energy)
	#print(initial_potential_energy)
	#print(energy_in_system)
	#print(initial_speed)
	#print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var vector_between_weight_and_centre = (pendulum_centre.position - position)
	var angle_between_weight_and_centre = atan2(vector_between_weight_and_centre.x, vector_between_weight_and_centre.y)
	
	var vector_tangent_to_pendulum = Vector2(-cos(angle_between_weight_and_centre), sin(angle_between_weight_and_centre))
	
	current_potential_energy = 200 * (min_pendulum_height - position.y)
	current_kinetic_energy = energy_in_system - current_potential_energy
	
	if current_kinetic_energy < 10:
		current_kinetic_energy = 10
		current_potential_energy = energy_in_system - current_kinetic_energy
		direction_of_pendulum *= -1
	
	if current_potential_energy < 0:
		current_potential_energy = 0
		current_kinetic_energy = energy_in_system
	
	current_speed = sqrt(2*current_kinetic_energy)
	
	current_velocity = direction_of_pendulum * vector_tangent_to_pendulum * current_speed
	
	#print(rad_to_deg(angle_between_weight_and_centre))
	#print(vector_tangent_to_pendulum)
	#print()
	#
	#print(current_kinetic_energy)
	#print(current_potential_energy)
	#print(energy_in_system)
	#print(current_velocity)
	#print()
	#print()
	
	
	velocity = current_velocity
	move_and_slide()
