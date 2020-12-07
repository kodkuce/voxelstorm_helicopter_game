class_name Block
extends RigidBody

var pos : Vector3

func recive_dmg():
	$DestroyTimer.start(rand_range(8,13))

func _on_DestroyTimer_timeout():
	if pos.distance_to( transform.origin ) > 1:
		remove_self()
	
func remove_self():
	mode = RigidBody.MODE_STATIC
	$DestroyTimer.stop()
	set_process(false)

func _ready():
	pos = transform.origin
	sleeping = true
