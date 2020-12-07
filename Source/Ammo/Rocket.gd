extends RigidBody

func _ready():
	#$Lounch_Back_Smoke.transform = transform.origin
	#$Lounch_Back_Smoke.restart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#add_central_force(transform.basis.z*10000*delta)
	#apply_impulse() (transform.basis.z*10000*delta)
	pass


func _on_AutoExplodeTimer_timeout():
	boom()

func boom():
	queue_free()


func _on_StabilzeTimer_timeout():
	#var start_angle = transform.basis.z.angle_to(Vector3.UP)
	#print(start_angle)
	
	#if rotation_degrees.x>0:
	#	add_force(Vector3.UP*100, transform.basis.z)
	#print( rotation_degrees.x )
	#pass # Replace with function body.
	pass


func _on_BurnTimer_timeout():
	#apply_central_impulse(transform.basis.z*100)
	pass # Replace with function body.


func _on_Rocket_body_entered(body):
	queue_free()
	Global.spawn_something("explosion_particle_cpu",
	 get_global_transform().origin , null)
	
	#effect body elements around
	var hited = $ExplosionEfectDetector.get_overlapping_bodies()
	for h in hited:
		if h is Block:
			var dir = h.get_global_transform().origin - get_global_transform().origin
			var force = clamp( 10 - h.get_global_transform().origin.distance_to(get_global_transform().origin) ,1,10)
			h.apply_central_impulse( (dir.normalized()+Vector3.UP*0.3) * force * rand_range(2,8) )
			h.recive_dmg()
		if h is PVO:
			h.recive_dmg()
