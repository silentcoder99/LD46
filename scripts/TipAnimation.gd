extends Label

var float_speed = 0.6
var fade_speed = 0.03
var text_color = Color(1.0, 1.0, 1.0, 1.0)

func _ready():
	#Centre rect
	rect_position.x -= rect_size.x / 2

func set_amount(amount):
	text = ""
	
	if(amount < 0):
		text += "-"
		modulate = Color(1.0, 0.0, 0.0)
	
	text += "$" + str(abs(amount))
	
func set_message(message, color = Color(1.0, 1.0, 1.0)):
	modulate = color
	text = message

func _process(delta):
	margin_top -= float_speed
#	text_color.a -= fade_speed
#	set("custom_colors/font_color", text_color)
	modulate.a -= fade_speed
	
	if modulate.a <= 0:
		queue_free()