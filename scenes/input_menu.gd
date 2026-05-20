extends Control

var grid_button_scene = preload("res://scenes/grid_button.tscn")
var list_button_scene = preload("res://scenes/list_button.tscn")
const main_buttons = {
	Global.State.ATTACK: "Attack",
	Global.State.DEFEND: "Defend",
	Global.State.SWAP: "Swap",
	Global.State.ITEM: "Item",
}

func _ready() -> void:
	#create_attack_buttons()
	#create_grid_buttons(Global.State.MAIN, main_buttons)
	#create_swap_buttons()
	create_item_buttons()
	

func create_grid_buttons(state: Global.State, data: Dictionary):
	for button in $GridMenu.get_children():
		button.queue_free()
	for key in data:
		var grid_button = grid_button_scene.instantiate()
		grid_button.setup(state, key, data[key])
		$GridMenu.add_child(grid_button)
		grid_button.connect("press", button_handler)

func create_list_buttons(state: Global.State, data: Dictionary):
	for button in $ScrollContainer/ListMenu.get_children():
		button.queue_free()
	for d in data:
		var list_button = list_button_scene.instantiate()
		list_button.setup(state, d, data)
		$ScrollContainer/ListMenu.add_child(list_button)
		list_button.connect("press", button_handler)

func create_attack_buttons():
	var current_monster_attacks = Global.monster_data[Global.current_monster]["attacks"]
	var monster_attack_data := {}
	for attack in current_monster_attacks:
		monster_attack_data[attack] = Global.attack_data[attack]["name"]
	create_grid_buttons(Global.State.ATTACK, monster_attack_data)

func create_swap_buttons():
	var owned_monsters = Global.monsters
	var owned_monster_data := {}
	for monster in owned_monsters:
		owned_monster_data[monster] = Global.monster_data[monster]
	create_list_buttons(Global.State.SWAP, owned_monster_data)

func create_item_buttons():
	var owned_items = Global.items
	var owned_item_data := {}
	for item in owned_items:
		owned_item_data[item] = Global.item_data[item]
	create_list_buttons(Global.State.ITEM, owned_item_data)


func button_handler(state, type):
	print("test")
