extends CanvasLayer

func _ready():
	OS.set_window_maximized(true)
	deselect()

func select(label):
	label.modulate.a = 1
	
func deselect():
	$Back.modulate.a = 0.5
	
func _on_Back_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Back_mouse_entered():
	select($Back)

func _on_Back_mouse_exited():
	deselect()