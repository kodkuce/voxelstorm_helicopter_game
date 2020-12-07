extends Control

var helicopter_frame : MeshInstance

func _ready():
	helicopter_frame = get_node("/root/myroot/World/Helicopter/Looks/Helicopter")
	$HBoxContainer/camo1.color = helicopter_frame.get_surface_material(0).albedo_color
	$HBoxContainer/camo2.color = helicopter_frame.get_surface_material(1).albedo_color
	$HBoxContainer/camo3.color = helicopter_frame.get_surface_material(2).albedo_color
	
func _on_StartGame_button_down():
	hide()
	Events.emit_signal("start_game")


func _on_color_changed(color, what):
	var mat = helicopter_frame.get_surface_material(what)
	mat.albedo_color = color
