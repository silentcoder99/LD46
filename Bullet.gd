extends Area2D

export var speed = 6000
export var knockback = 2000
export var agro_time = 40

var fowards = Vector2()

var life_time = 0.2

var trail_points = PoolVector2Array()

var player

func _ready():
	fowards = transform.x
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
	position += fowards * speed * delta
	
	life_time -= delta
	if life_time <= 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if is_body_enemy(body):
		if not body.is_immune:
			body.agro_timer = agro_time
			body.apply_central_impulse(transform.x * knockback)
			body.health -= 1
			body.go_immune()
			
			if body.health <= 0:
				body.queue_free()
				player.life_time += 2
			
	queue_free()
		
func is_body_enemy(body):
	return "enemy" in body.get_groups()