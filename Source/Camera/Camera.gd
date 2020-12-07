extends Camera

export var fallow:bool = false
var player:KinematicBody
var offset:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Helicopter")
	offset = transform.origin - Vector3( 0,player.transform.origin.y, 0)
	Events.connect("start_game",self,"_on_start_game")
	#print( offset )
	#print( player )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fallow:
		var aimpos = player.transform.origin + offset + player.transform.basis.z.normalized() * (50 + player.control_axis.z*75)
		transform.origin = transform.origin.linear_interpolate(aimpos,0.7*delta)
		#transform.origin = aimpos

func _on_start_game():
	fallow = true
