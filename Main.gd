extends Node2D

export (int) var spawn_amount
export (int) var spawn_area
export (PackedScene) var Enemy
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
		
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.position = spawn_position
		
func _process(delta):
	time_limit -= delta
	if time_limit <= 0:
		get_tree().reload_current_scene()
		
	$UI/DebugLabel.text = str($Player.nearby_enemies) + '\n'
	
	$UI/HealthLabel.text = "Health %d" % $Player.health
	
	if damage_fade >= 0:
		$UI/DamageRect.color = transparent.linear_interpolate(opaque, damage_fade)
		damage_fade -= delta
	
func damage_splash():
	damage_fade = 1
	

func _on_SpawnTimer_timeout():
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	
	if num_enemies < spawn_amount:
		$SpawnPath/SpawnPosition.set_offset(randi())
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.position = $SpawnPath/SpawnPosition.position