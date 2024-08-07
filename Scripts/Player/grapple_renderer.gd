extends Node2D
class_name GrappleRenderer

@onready var player = $".."
@onready var grapple_offset = $GrappleOffset

var line_thickness = 0.5


enum GRAPPLE_STATE {NULL, ENTERING, EXITING, EXTENDED, EXTENDING}
var current_grapple_state: GRAPPLE_STATE = GRAPPLE_STATE.NULL
const NUMBER_OF_CURVES = 2

func _draw() -> void:
	
	if current_grapple_state == GRAPPLE_STATE.NULL:
		return
	
	if current_grapple_state == GRAPPLE_STATE.EXTENDING:
		_draw_extending_grapple_line()
	
	if current_grapple_state == GRAPPLE_STATE.EXTENDED:
		_draw_extended_grapple_line()

func _physics_process(delta) -> void:
	queue_redraw()


func _draw_enter_grapple_line() -> void:
	var t = 1 #some value between 0 and 1 determined by current time since entering state, and some velocity
	var grapple_line_end = Vector2.ZERO.lerp(player.current_grapple_point.position - player.position, t)

func _draw_extending_grapple_line() -> void:
	var point_array = _get_array_of_curve_points()
	var curve_array = _create_bezier_curve_from_point_array(point_array)
	_draw_bezier_curve_from_array(curve_array)

func _draw_extended_grapple_line() -> void:
	var start_point: Vector2 = _get_start_point()
	var end_point: Vector2 = _get_end_point()
	
	draw_line(start_point, end_point, Color.WHITE, line_thickness)

func _get_array_of_curve_points() -> PackedVector2Array:
	var number_of_points = 2*NUMBER_OF_CURVES + 1
	var array_of_points = PackedVector2Array()
	
	var start_point: Vector2 = _get_start_point()
	var end_point: Vector2 = _get_end_point()
	
	var vector_of_line = end_point - start_point
	var point_spacing = vector_of_line / (number_of_points-1)
	
	var normal_to_line = Vector2(vector_of_line.y, -vector_of_line.x).normalized()
	
	var distance_from_full_extension =  vector_of_line.length() - player.MAX_GRAPPLE_LENGTH
	
	print('points')
	for index in range(number_of_points):
		var point_position = start_point + index*point_spacing
		
		if _is_odd(index):
			point_position += distance_from_full_extension/2 * normal_to_line * cos(PI/2 * index - PI/2)
		
		array_of_points.append(point_position)
	
	return array_of_points

func _create_bezier_curve_from_point_array(point_array: PackedVector2Array) -> PackedVector2Array:
	var bezier_curves_array = PackedVector2Array()
	
	for i in range(NUMBER_OF_CURVES):
		var point1 = point_array[2*i]
		var point2 = point_array[2*i + 1]
		var point3 = point_array[2*i + 2]
		var bezier_curve_array = _create_bezier_curve(point1, point2, point3)
		bezier_curves_array.append_array(bezier_curve_array)
	
	return bezier_curves_array

func _draw_bezier_curve_from_array(curve_array: PackedVector2Array) -> void:
	for i in range(curve_array.size()-1):
		draw_line(curve_array[i], curve_array[i+1], Color.WHITE, line_thickness)


func _is_odd(integer) -> bool:
	var as_float = float(integer)
	if as_float/2 == roundi(as_float/2):
		print('true')
		return false
	return true

func _create_bezier_curve(point1: Vector2, point2: Vector2, point3: Vector2, steps = 25) -> PackedVector2Array:
	var bezier_curve_array = PackedVector2Array()
	
	for i in range(steps):
		var fraction_step = i/(float(steps)-1)
		var q0 = point1.lerp(point2, fraction_step)
		var q1 =  point2.lerp(point3, fraction_step)
		
		var point_on_curve = q0.lerp(q1, fraction_step)
		
		bezier_curve_array.append(point_on_curve)
	
	return bezier_curve_array

func _get_start_point() -> Vector2:
	if player.is_facing_right:
		return Vector2.ZERO + grapple_offset.position
	return Vector2.ZERO + Vector2(-grapple_offset.position.x, grapple_offset.position.y)

func _get_end_point() -> Vector2:
	return player.current_grapple_point.position - player.position
