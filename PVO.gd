class_name PVO
extends Spatial

export var pvo_bullet : PackedScene
onready var tilt = $Base/Rot/Tilt
onready var fire_rate_timer = $FireRateTimer
onready var t1be = $Base/Rot/Tilt/turret1_barrel_end
onready var t2be = $Base/Rot/Tilt/turret2_barrel_end
onready var rc_aim = $Base/Rot/Tilt/AimDetector

var target = null
var hp = 100
var dead = false

func _ready():
	$HpBar3D.texture = $HpBar3D/Viewport/.get_texture()
	Global.pvo_to_kill += 1
	Events.connect("gameower",self,"_on_gameower")

func _process(delta):
	if target != null:
		var tpos = target.get_global_transform().origin
		tilt.look_at( tpos, Vector3.UP )

		if fire_rate_timer.is_stopped() and rc_aim.is_colliding():
			var b1 : RigidBody = pvo_bullet.instance()
			var b2 : RigidBody = pvo_bullet.instance()
			Global.garbage.add_child(b1)
			Global.garbage.add_child(b2)
			b1.transform.origin = t1be.get_global_transform().origin
			b1.apply_central_impulse(-t1be.get_global_transform().basis.z * 130)
			b2.transform.origin = t2be.get_global_transform().origin
			b2.apply_central_impulse(-t2be.get_global_transform().basis.z * 140)
			fire_rate_timer.start()

func recive_dmg():
	if dead:
		return
	
	hp += -25
	$HpBar3D/Viewport/HpBar2D.value = hp
	if hp <= 0:
		dead = true
		set_process(false)
		$Death_smoke.restart()
		Events.emit_signal("pvo_destroyed")

func _on_Radar_body_entered(body):
	target = body

func _on_Radar_body_exited(body):
	if target == body:
		target = null

func _on_gameower():
	set_process(false)
