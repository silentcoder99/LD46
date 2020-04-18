extends Node2D

export (int) var spawn_amount
export (int) var spawn_area
export (PackedScene) var Partier
export var time_limit = 100

var damage_fade = 0
var transparent
var opaque

func _ready():
	OS.set_window_maximized(true)
	
	randomize()
	
	transparent = $UI/DamageRect.color
	opaque = Color(transparent.r, transparent.g, transparent.b, 0.4)
	
	for i in range(spawn_amount):
		var spawn_position = Vector2()
		spawn_position.x = randi() % (spawn_area * 2) - spawn_area
		spawn_position.y = randi() % (spawn_area * 2) - spawn_area
		
		var partier = Partier.instance()
		add_child(partier)
		partier.position = spawn_position
		
func _process(delta):
	time_limit -= delta
	if time_limit <= 0:
		get_tree().reload_current_scene()
		
	$UI/DebugLabel.text = str($Player.nearby_partiers) + '\n'
	
	if damage_fade >= 0:
		$UI/DamageRect.color = transparent.linear_interpolate(opaque, damage_fade)
		damage_fade -= delta
	
func damage_splash():
	damage_fade = 1
