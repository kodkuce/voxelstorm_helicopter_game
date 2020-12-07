extends Control

var start_pvos

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("start_game",self,"_on_start_game")
	Events.connect("player_rec_dmg",self,"_on_player_rec_dmg")
	Events.connect("pvo_destroyed",self,"_on_pvo_destroy")

func _on_start_game():
	show()
	start_pvos = str(Global.pvo_to_kill)
	update_objective_text()

func _on_player_rec_dmg():
	$PlayerHP.value += -2
	if( $PlayerHP.value == 0 ):
		Events.emit_signal("gameower")
		

func _on_pvo_destroy():
	Global.pvo_to_kill += -1
	update_objective_text()
	if Global.pvo_to_kill == 0:
		Events.emit_signal("player_won")

func update_objective_text():
	$Objective.text = "PVO : " + str(Global.pvo_to_kill) + " / " + start_pvos
