extends KinematicBody

export var controls_on:bool
export var turn_speed:float = 1
export var forward_speed:float = 1
export var back_speed:float = 0.5
export var strafe_speed:float = 0.5
var control_axis = Vector3.ZERO
var velocity = Vector3.ZERO
onready var height_raycast = $Height_raycast
var height_atm : float
var gameower = false


func _ready():
	$AnimationPlayer.play("EliseSpin")
	Events.connect("start_game",self,"_on_start_game")
	Events.connect("gameower",self,"_on_gameower")

func _process(delta):
	if controls_on:
		process_controls(delta)


#make controls like holding increses power -1 to 1
func process_controls(delta):
	
	if Input.is_action_pressed("ui_up"):
		control_axis.z += 2 * delta
	if Input.is_action_pressed("ui_down"):
		control_axis.z += -2 * delta
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		control_axis.z = lerp(control_axis.z, 0, 2 * delta)
		if abs( control_axis.z ) < 0.1:
			control_axis.z = 0

	if not Input.is_action_pressed("strafe"):
		if Input.is_action_pressed("ui_right"):
			control_axis.y += -2 * delta
		if Input.is_action_pressed("ui_left"):
			control_axis.y += 2 * delta
	if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") or Input.is_action_pressed("strafe"):
		control_axis.y = lerp(control_axis.y, 0, 2 * delta)
		if abs( control_axis.y ) < 0.1:
			control_axis.y = 0
	
	if Input.is_action_pressed("strafe") and Input.is_action_pressed("ui_right"):
		control_axis.x += -2 * delta
	if Input.is_action_pressed("strafe") and Input.is_action_pressed("ui_left"):	
		control_axis.x += 2 * delta
	if not Input.is_action_pressed("strafe"):
		control_axis.x = lerp(control_axis.x, 0, 2 * delta)
		if abs( control_axis.x ) < 0.1:
			control_axis.x = 0

	control_axis.x = clamp( control_axis.x, -1, 1 )
	control_axis.y = clamp( control_axis.y, -1, 1 )
	control_axis.z = clamp( control_axis.z, -1, 1 )

func _physics_process(delta):
	fly(delta)

func fly(delta):
	if height_raycast.is_colliding():
		height_atm =  get_global_transform().origin.distance_to(height_raycast.get_collision_point())
	
	rotate_y( control_axis.y * delta * turn_speed )
	$Looks.look_at( get_global_transform().origin + -get_global_transform().basis.z.normalized() + Vector3.UP * 0.2 * control_axis.z, Vector3.UP )
	
	var local_forward
	if control_axis.z < 0:
		local_forward = get_global_transform().basis.z.normalized() * control_axis.z * back_speed
	else:
		local_forward = get_global_transform().basis.z.normalized() * control_axis.z * forward_speed
	var local_side = get_global_transform().basis.x.normalized() * control_axis.x * strafe_speed
	
	var height_reg = Vector3.ZERO
	if height_atm < 19.9:
		height_reg = Vector3.UP * (20 - height_atm) * 10
	if height_atm > 20.1:
		height_reg = Vector3.UP * ( height_atm - 20 ) * -10
		
	if gameower:
		if height_atm > 1:
			height_reg = Vector3.UP * - 10
			$AnimationPlayer.playback_speed = clamp( $AnimationPlayer.playback_speed - delta,0,1 )
		else:
			height_reg = Vector3.ZERO
			set_physics_process(false)
			set_process(false)
	
	var global_velocity = move_and_slide( local_forward + local_side + height_reg )
	velocity = to_local(global_velocity + transform.origin)

func _on_start_game():
	controls_on = true
	
func _on_gameower():
	controls_on = false
	gameower = true
	Global.spawn_something("explosion_particle_cpu",
	 get_global_transform().origin , null)
