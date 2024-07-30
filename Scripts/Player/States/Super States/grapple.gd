extends State
class_name GrappleState

@export var grapple_renderer: GrappleRenderer

var vector_to_grapple_point: Vector2
var angle_from_grapple_point: float
var length_to_grapple_point: float

var length_of_grapple_rope: float = context.MAX_GRAPPLE_LENGTH

func enter() -> void:
	super()
	context.is_grappling = true
	vector_to_grapple_point = context.current_grapple_point.position - context.position
	angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)
	length_to_grapple_point = vector_to_grapple_point.length()

func physics_update(delta):
	super(delta)
	
	vector_to_grapple_point = context.current_grapple_point.position - context.position
	angle_from_grapple_point = atan2(vector_to_grapple_point.x, -vector_to_grapple_point.y)

func exit() -> void:
	context.is_grappling = false

func _draw_grapple_line() -> void:
	context.grapple_line.add_point(context.current_grapple_point.position - context.position)
	context.grapple_line.add_point(Vector2.ZERO)

func _redraw_grapple_line() -> void:
	context.grapple_line.set_point_position(context.grapple_line.get_point_count() - 1, Vector2.ZERO)
	context.grapple_line.set_point_position(0, context.current_grapple_point.position - context.position)

func _remove_grapple_line() -> void:
	context.grapple_line.clear_points()
