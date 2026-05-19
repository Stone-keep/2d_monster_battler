extends Control

var grid_button_scene = preload("res://scenes/grid_button.tscn")
const main_buttons = {
	Global.State.ATTACK: "Attack",
	Global.State.DEFEND: "Defend",
	Global.State.SWAP: "Swap",
	Global.State.ITEM: "Item",
}

func _ready() -> void:
	create_grid_buttons(Global.State.MAIN, main_buttons)

func create_grid_buttons(state: Global.State, data: Dictionary):
	for button in $GridContainer.get_children():
		button.queue_free()
	for key in data:
		var grid_button = grid_button_scene.instantiate()
		grid_button.setup(state, key, data[key])
		$GridContainer.add_child(grid_button)
		grid_button.connect("press", button_handler)

func button_handler(state, type):
	print(state)
	print(type)