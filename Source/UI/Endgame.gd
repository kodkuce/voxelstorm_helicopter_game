extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("player_won",self,"_on_player_won")
	Events.connect("gameower",self,"_on_gameower")

func _on_player_won():
	show()
	$YouWon.show()
	
func _on_gameower():
	show()
	$Gameower.show()
