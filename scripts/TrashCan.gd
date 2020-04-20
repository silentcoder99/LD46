extends StaticBody2D

export (Texture) var trash_can_texture
export (Texture) var fire_texture
export (PackedScene) var TipAnimation
export (PackedScene) var Arrow

export var min_disaster_delay = 5
export var max_disaster_delay = 10

export var repair_cost = 10

var ready_to_combust = false
var ready_to_extinguish = false
var on_fire = false
var repairing = false

var player

func update_frame_time(frame_time, offset):
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.seek(offset, true)

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	$CombustTimer.wait_time = rand_range(min_disaster_delay, max_disaster_delay)
	$CombustTimer.start()

func _process(delta):
	$RepairBar.value = $RepairBar.max_value - ($RepairTimer.time_left / $RepairTimer.wait_time) * $RepairBar.max_value

func add_arrow(blip):
	var arrow = Arrow.instance()
	arrow.fire = self
	player.add_child(arrow)
	
	if blip:
		arrow.blip()

func combust():
	on_fire = true
	$FireSprite.show()
	$DisasterSound.play()
	add_arrow(false)
	
func repair():
	repairing = true
	$RepairTimer.start()
	$RepairBar.show()
	
	player.money -= repair_cost
	player.score += 5
	var tip_animation = TipAnimation.instance()
	tip_animation.set_amount(-repair_cost)
	tip_animation.rect_position = position + Vector2(0, -36)
	get_tree().get_root().add_child(tip_animation)

func extinguish():
	$RepairBar.hide()
	
	on_fire = false
	repairing = false
	$FireSprite.hide()
	$ResolvedSound.play()
	add_arrow(true)
	
	$CombustTimer.wait_time = rand_range(min_disaster_delay, max_disaster_delay)
	$CombustTimer.start()

func _on_CombustTimer_timeout():
	ready_to_combust = true

func check_combustion():
	if ready_to_combust:
		combust()
		ready_to_combust = false
		
	if ready_to_extinguish:
		extinguish()
		ready_to_extinguish = false

func _on_FixArea_body_entered(body):
	if "player" in body.get_groups():
		if on_fire and $RepairTimer.time_left == 0:
			if player.money >= repair_cost:
				repair()
			else :
				var tip_animation = TipAnimation.instance()
				tip_animation.set_message("Not enough cash", Color(1.0, 0.0, 0.0))
				tip_animation.rect_position = position + Vector2(0, -36)
				get_tree().get_root().add_child(tip_animation)
	elif "partier" in body.get_groups():
		if on_fire:
			body.hurt()
			body.shoo(position.direction_to(body.position))

func _on_RepairTimer_timeout():
	ready_to_extinguish = true
