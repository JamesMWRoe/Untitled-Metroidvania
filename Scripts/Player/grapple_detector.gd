extends Area2D

var is_grapple_point: bool

var grapple_point: GrapplePoint

signal grapple_point_found

func _on_area_entered(area) -> void:
	if not is_class('grapple_point'):
		return
	

func _physics_process(delta) -> void:
	if not is_grapple_point:
		return
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, grapple_point.position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result["collider"] == grapple_point:
		#tell player grapple is possible
		grapple_point_found.emit(grapple_point)
