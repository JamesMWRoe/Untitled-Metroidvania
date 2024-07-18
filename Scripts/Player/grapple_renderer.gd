extends Node2D

@onready var player = $".."
@onready var grapplefall = $"../StateMachine/GrappleFall"

const NUMBER_OF_CURVES = 2

var is_grapple_falling = false

func _ready():
	grapplefall.state_begun.connect(_grapple_fall_started)
	grapplefall.state_ended.connect(_grapple_fall_ended)

func _draw() -> void:
	
	if not player.current_grapple_point:
		return
	
	if not is_grapple_falling:
		return
	
	var point_array = _get_array_of_curve_points()
	
	var curve_array = _create_bezier_curve_from_point_array(point_array)
	
	_draw_bezier_curve_from_array(curve_array)

func _physics_process(delta) -> void:
	if not is_grapple_falling:
		return
	queue_redraw()

func _grapple_fall_started() -> void:
	is_grapple_falling = true

func _grapple_fall_ended() -> void:
	is_grapple_falling = false
	queue_redraw()

func _draw_grapple_line() -> void:
	var point_array = _get_array_of_curve_points()
	var curve_array = _create_bezier_curve_from_point_array(point_array)
	_draw_bezier_curve_from_array(curve_array)

func _get_array_of_curve_points() -> PackedVector2Array:
	var number_of_points = 2*NUMBER_OF_CURVES + 1
	var array_of_points = PackedVector2Array()
	
	var start_point: Vector2 = Vector2.ZERO
	var end_point: Vector2 = player.current_grapple_point.position - player.position
	
	var vector_of_line = end_point - start_point
	var point_spacing = vector_of_line / (number_of_points-1)
	
	var normal_to_line = Vector2(vector_of_line.y, -vector_of_line.x).normalized()
	
	var distance_from_full_extension =  vector_of_line.length() - grapplefall.length_of_grapple_rope
	
	print('points')
	for index in range(number_of_points):
		var point_position = start_point + index*point_spacing
		
		if _is_odd(index):
			point_position += distance_from_full_extension/2 * normal_to_line * cos(PI/2 * index - PI/2)
		
		print(index)
		print(point_position)
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
		draw_line(curve_array[i], curve_array[i+1], Color.WHITE, 1)


func _is_odd(integer) -> bool:
	print(integer)
	print('is this odd?')
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
