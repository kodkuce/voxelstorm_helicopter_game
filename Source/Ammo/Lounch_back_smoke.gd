extends CPUParticles

func _ready():
	restart()
	pass # Replace with function body.


func _on_DestroyTimer_timeout():
	get_parent().queue_free()
