extends RigidBody



func _on_DestroySelfTimer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_EnableCollisionTimer_timeout():
	collision_layer = 1
	collision_mask = 1
	pass # Replace with function body.
