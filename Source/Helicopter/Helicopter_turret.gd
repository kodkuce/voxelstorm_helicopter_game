extends MeshInstance


export var bullet : Resource
export var bullet_shell : Resource
export var magazine_size = 20
var atm_bullets = magazine_size
var can_fire = true
onready var fire_rate_timer = $FireRateTimer
onready var reload_timer = $ReloadTimer
onready var garbage = Global.garbage
onready var turret_shell_dispencer = $turret_shell_dispencer
onready var turret_barrel_end = $turrent_barrel_end
#onready var shell_pool = get_node("/root/World/Shell_Pool")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("start_game",self,"_on_start_game")
	Events.connect("gameower",self,"_on_gameower")
	set_process(false)

func _process(delta):
	if Input.is_action_pressed("fire_turret"):
		try_fire()

func try_fire():
	if atm_bullets > 0 and fire_rate_timer.is_stopped():
		fire_rate_timer.start()
		
		var fired_bullet:RigidBody = bullet.instance()
		garbage.add_child(fired_bullet)
		fired_bullet.transform = turret_barrel_end.get_global_transform()
		fired_bullet.apply_central_impulse( get_global_transform().basis.z * 200 )
		
		#lower gravity scale when tilt forward so dont shoot that much close
		if fired_bullet.rotation_degrees.x > 0:
			fired_bullet.gravity_scale += -fired_bullet.rotation_degrees.x/2

		#drop bullet shell
		var fired_bullet_shell:RigidBody = bullet_shell.instance()
		garbage.add_child(fired_bullet_shell)
		fired_bullet_shell.transform = turret_shell_dispencer.get_global_transform()
		fired_bullet_shell.apply_central_impulse( turret_shell_dispencer.get_global_transform().basis.x * -rand_range(10,20) ) #-rand_range(1,100) #Vector3( 50 ,1,0)
		Global.audio_play("turret_shoot_sfx",0)

		atm_bullets += -1
		if atm_bullets == 0:
			reload_timer.start()
			Global.audio_play("turret_reload_sfx",0)

func _on_ReloadTimer_timeout():
	atm_bullets = magazine_size

func _on_start_game():
	set_process(true)
	
func _on_gameower():
	set_process(false)
