extends Node

var shell_pool : Spatial
var bullet_pool : Spatial
var rocket_pool : Spatial
var lock_rocket_pool : Spatial
var audio_pool : Spatial

#SFXes
onready var turret_shoot_sfx : AudioStream = load("res://Assets/SFX/Turret_shoot.ogg")
onready var turret_reload_sfx : AudioStream = load("res://Assets/SFX/Turret_reload.ogg")
onready var rocket_lounch_sfx : AudioStream = load("res://Assets/SFX/Rocket_lounch.ogg")
onready var rocket_reload_sfx : AudioStream = load("res://Assets/SFX/Rocket_reload.ogg")

#SPAWNS
var world
var garbage
onready var explosion_particle_cpu : PackedScene = load("res://Source/Ammo/Explosion.tscn")
onready var lounch_back_smoke : PackedScene = load("res://Source/Ammo/Lounch_back_smoke.tscn")


var pvo_to_kill = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	world = get_node("/root/myroot/World")
	if world == null:
		get_tree().paused = true
		printerr("MISSING WORLD NODE")

	garbage = Spatial.new()
	garbage.name = "Garbage"
	world.add_child(garbage)

	shell_pool = Spatial.new()
	world.add_child(shell_pool)
	shell_pool.name = "Shell_pool"
	
	audio_pool = Spatial.new()
	audio_pool.name = "Audio_Pool"
	world.add_child(audio_pool)
	for n in range(16):
		var audio_s = AudioStreamPlayer.new()
		audio_pool.add_child(audio_s)

func audio_play(soundname,vol):
	var found_sound = null
	match soundname:
		"turret_shoot_sfx":
			found_sound = turret_shoot_sfx
		"turret_reload_sfx":
			found_sound = turret_reload_sfx
		"rocket_lounch_sfx":
			found_sound = rocket_lounch_sfx
		"rocket_reload_sfx":
			found_sound = rocket_reload_sfx

	if found_sound != null:
		for n in range(16):
			var ap : AudioStreamPlayer = audio_pool.get_child(n)
			if not ap.playing:
				ap.stream = found_sound
				ap.volume_db = vol
				ap.play()
				return
				
func spawn_something(what, pos, rot):
	var thing = null
	match what:
		"explosion_particle_cpu":
			thing = explosion_particle_cpu
		"lounch_back_smoke":
			thing = lounch_back_smoke
			
	if thing != null:
		var spawned_thing = thing.instance()
		garbage.add_child(spawned_thing)
		spawned_thing.transform.origin = pos
		if rot != null:
			spawned_thing.rotation_degrees = rot
		
