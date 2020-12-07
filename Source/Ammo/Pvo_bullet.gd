extends RigidBody

func _on_Bullet_body_entered(body):
	queue_free()
	Events.emit_signal("player_rec_dmg")
	


func _on_AutoDestroyTimer_timeout():
	queue_free()
