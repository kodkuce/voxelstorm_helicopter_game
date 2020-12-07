extends RigidBody


func _on_Bullet_body_entered(body):
	queue_free()
	if body is PVO:
		body.recive_dmg()
