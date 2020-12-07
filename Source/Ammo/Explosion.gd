extends CPUParticles

func _ready():
	scale = rand_range(3,5)*Vector3.ONE
	restart()

func _on_DestroyTimer_timeout():
	queue_free()

