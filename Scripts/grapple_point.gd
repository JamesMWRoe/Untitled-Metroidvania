extends Area2D

func _on_body_entered(body):
	if body.has_method("set_grapple_point"):
		body.set_grapple_point(self)


func _on_body_exited(body):
	if body.has_method("disengage_grapple_point"):
		body.disengage_grapple_point()
