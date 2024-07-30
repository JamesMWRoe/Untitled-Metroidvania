extends Area2D

@onready var player = $".."
@onready var collision_shape = $CollisionShape2D

var is_grapple_point: bool

var grapple_points_within_range: Array[GrapplePoint] = []
var grapple_points_in_sight: Array[GrapplePoint] = []
var current_grapple_point: GrapplePoint



func _ready():
	collision_shape.shape.radius = player.MAX_GRAPPLE_LENGTH

func _physics_process(delta) -> void:
	
	if not player.current_grapple_point == null and player.is_grappling:
		return
	
	grapple_points_within_range = []
	
	for area in get_overlapping_areas():
		if area.has_method('is_grapple_point'):
			grapple_points_within_range.append(area)
	
	grapple_points_in_sight = _check_if_grapple_points_are_in_sight(grapple_points_within_range)
	
	if grapple_points_in_sight.is_empty():
		player.current_grapple_point = null
	else:
		player.current_grapple_point = grapple_points_in_sight[0]

func _check_if_grapple_points_are_in_sight(grapple_points) -> Array[GrapplePoint]:
	var space_state = get_world_2d().direct_space_state
	var sight_array: Array[GrapplePoint] = []
	
	for grapple_point in grapple_points_within_range:
		var query = PhysicsRayQueryParameters2D.create(global_position, grapple_point.position)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			sight_array.append(grapple_point)
	
	return sight_array
