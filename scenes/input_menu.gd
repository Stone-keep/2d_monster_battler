extends Control

var grid_button_scene = preload("res://scenes/grid_button.tscn")
const main_buttons = {
	Global.State.ATTACK: "Attack",
	Global.State.DEFEND: "Defend",
	Global.State.SWAP: "Swap",
	Global.State.ITEM: "Item",
}

func _ready() -> void:
	create_attack_buttons()
	#create_grid_buttons(Global.State.MAIN, main_buttons)
	

func create_grid_buttons(state: Global.State, data: Dictionary):
	for button in $GridContainer.get_children():
		button.queue_free()
	for key in data:
		var grid_button = grid_button_scene.instantiate()
		grid_button.setup(state, key, data[key])
		$GridContainer.add_child(grid_button)
		grid_button.connect("press", button_handler)

func create_attack_buttons():
	var current_monster_attacks = Global.monster_data[Global.current_monster]["attacks"]
	var monster_attack_data := {}
	for attack in current_monster_attacks:
		monster_attack_data[attack] = Global.attack_data[attack]["name"]
	create_grid_buttons(Global.State.ATTACK, monster_attack_data)

func button_handler(state, type):
	print("test")
