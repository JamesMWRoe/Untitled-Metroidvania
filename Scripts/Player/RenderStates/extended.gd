extends RenderState

@export
var idle: RenderState

func render():
	var start_point: Vector2 = Vector2.ZERO
	var end_point: Vector2 = context.current_grapple_point.position - context.position
	
	draw_line(start_point, end_point, Color.WHITE, 1)
