extends Sprite

var fire
var radius = 60

var min_fade_distance = 60
var max_fade_distance = 80

func blip():
	$AnimationPlayer.play("blip")

func _process(delta):
	print("hi")
	position = Vector2()
	look_at(fire.position)
	position = transform.x * radius
	
	if fire.repairing:
		queue_free()
		
	var distance_to_fire = get_global_position().distance_to(fire.get_global_position())
	if distance_to_fire <= max_fade_distance:
		modulate.a = (distance_to_fire - min_fade_distance) / (max_fade_distance - min_fade_distance)
	else:
		modulate.a = 1

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()