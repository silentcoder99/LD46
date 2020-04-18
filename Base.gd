extends Area2D

export var growth_rate = 2
export var decay_rate = 0.5

export var radius = 50

var growth = 100
var growing = false

func _ready():
	$CollisionShape2D.shape.radius = radius

func _process(delta):
	update()
	
	if growing:
		growth += growth_rate * delta
	else:
		growth -= decay_rate * delta
		
	if growth <= 0:
		get_tree().reload_current_scene()
		
	if growth > 100:
		growth = 100
		
	$TimeLabel.text = "%.2f" % growth
	
func _draw():
	draw_circle(Vector2(0, 0), radius, Color(102 / 255.0, 58 / 255.0, 120 / 255.0, 0.6))

func _on_Base_area_entered(area):
	if is_area_player(area):
		growing = true

func _on_Base_area_exited(area):
	if is_area_player(area):
		growing = false

func is_area_player(area):
	print(area.get_groups())
	return "player_body" in area.get_groups()