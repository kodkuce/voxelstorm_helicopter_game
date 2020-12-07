extends MeshInstance

export var rocket : Resource
onready var fire_rate_timer = $FireRateTimer
onready var reload_timer = $ReloadTimer
var atm_slot = 0

onready var garbage = Global.garbage

func _ready():
	Events.connect("start_game",self,"_on_start_game")
	Events.connect("gameower",self,"_on_gameower")
	set_process(false)

func _process(delta):
	if Input.is_action_pressed("fire_rocket"):
		try_fire()

func try_fire():
	if atm_slot <= 3 and fire_rate_timer.is_stopped():
		fire_rate_timer.start()
		
		var fired_rocket:RigidBody = rocket.instance()
		garbage.add_child(fired_rocket)
		fired_rocket.transform = get_child(atm_slot).get_global_transform()
		fired_rocket.apply_central_impulse( get_global_transform().basis.z * 200 )
		Global.audio_play("rocket_lounch_sfx",-10)
		
		Global.spawn_something("lounch_back_smoke",fired_rocket.get_global_transform().origin, fired_rocket.rotation_degrees)
		
		#lower gravity scale when tilt forward so dont shoot that much close
		if fired_rocket.rotation_degrees.x > 0:
			fired_rocket.gravity_scale += -fired_rocket.rotation_degrees.x/2

		atm_slot += 1
		if atm_slot == 4:
			Global.audio_play("rocket_reload_sfx",0)
			reload_timer.start()

func _on_ReloadTimer_timeout():
	atm_slot = 0

func _on_start_game():
	set_process(true)

func _on_gameower():
	set_process(false)

