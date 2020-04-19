extends StaticBody2D

export (Texture) var trash_can_texture
export (Texture) var fire_texture
export (PackedScene) var TipAnimation

export var min_disaster_delay = 5
export var max_disaster_delay = 10

export var repair_cost = 10

var on_fire = false

var player

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	$CombustTimer.wait_time = rand_range(min_disaster_delay, max_disaster_delay)
	$CombustTimer.start()

func combust():
	on_fire = true
	$Sprite.texture = fire_texture
	$DisasterSound.play()
	
func extinguish():
	on_fire = false
	$Sprite.texture = trash_can_texture
	$ResolvedSound.play()
	
	player.money -= repair_cost
	var tip_animation = TipAnimation.instance()
	tip_animation.set_amount(-repair_cost)
	tip_animation.rect_position = position + Vector2(0, -36)
	get_tree().get_root().add_child(tip_animation)
	
	$CombustTimer.wait_time = rand_range(min_disaster_delay, max_disaster_delay)
	$CombustTimer.start()

func _on_CombustTimer_timeout():
	combust()

func _on_FixArea_body_entered(body):
	if "player" in body.get_groups():
		if on_fire:
			if player.money >= repair_cost:
				extinguish()
			else :
				var tip_animation = TipAnimation.instance()
				tip_animation.set_message("Not enough cash", Color(1.0, 0.0, 0.0))
				tip_animation.rect_position = position + Vector2(0, -36)
				get_tree().get_root().add_child(tip_animation)