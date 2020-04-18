extends Label

var float_speed = 0.6
var fade_speed = 0.03
var text_color = Color(1.0, 1.0, 1.0, 1.0)

func _process(delta):
	margin_top -= float_speed
#	text_color.a -= fade_speed
#	set("custom_colors/font_color", text_color)
	modulate.a -= fade_speed