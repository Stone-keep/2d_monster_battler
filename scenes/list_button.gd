extends Button

var state
var type
signal press(state, type)

func setup(menu_state, button_type, data):
	state = menu_state
	type = button_type
	$HBoxContainer/Label.text = data[button_type]["name"]
	$HBoxContainer/TextureRect.texture = load(data[button_type]["icon"])

func _on_pressed() -> void:
	press.emit(state, type)
