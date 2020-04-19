extends StaticBody2D

export (Texture) var trash_can_texture
export (Texture) var fire_texture

export var fire_chance = 0.1

func combust():
	$Sprite.texture = fire_texture
	$DisasterSound.play()

func _on_CombustTimer_timeout():
	if randf() < fire_chance:
		combust()