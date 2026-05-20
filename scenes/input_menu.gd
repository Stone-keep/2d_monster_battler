extends Control

var grid_button_scene = preload("res://scenes/grid_button.tscn")
var list_button_scene = preload("res://scenes/list_button.tscn")

const main_buttons = {
	Global.State.ATTACK: "Attack",
	Global.State.DEFEND: "Defend",
	Global.State.SWAP: "Swap",
	Global.State.ITEM: "Item",
}

var current_state: Global.State: set = state_handler

signal selected(state: Global.State, type)

func _ready() -> void:
	create_grid_buttons(Global.State.MAIN, main_buttons)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and current_state != Global.State.MAIN:
		current_state = Global.State.MAIN
		get_viewport().set_input_as_handled()


func create_grid_buttons(state: Global.State, data: Dictionary):
	for button in $GridMenu.get_children():
		button.queue_free()

	var first_button: Button = null

	for key in data:
		var grid_button = grid_button_scene.instantiate()
		grid_button.setup(state, key, data[key])
		$GridMenu.add_child(grid_button)
		grid_button.connect("press", button_handler)

		if first_button == null:
			first_button = grid_button

	focus_button(first_button)

func create_list_buttons(state: Global.State, data: Dictionary):
	for button in $ScrollContainer/ListMenu.get_children():
		button.queue_free()

	var first_button: Button = null

	for d in data:
		var list_button = list_button_scene.instantiate()
		list_button.setup(state, d, data)
		$ScrollContainer/ListMenu.add_child(list_button)
		list_button.connect("press", button_handler)

		if first_button == null:
			first_button = list_button

	focus_button(first_button)

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
	if state == Global.State.MAIN:
		current_state = type
		if type == Global.State.DEFEND:
			selected.emit(Global.State.DEFEND, type)
	else:
		selected.emit(state, type)

func focus_button(button: Button) -> void:
	await get_tree().process_frame
	if is_instance_valid(button):
		button.call_deferred("grab_focus")

func state_handler(value):
	current_state = value
	match value:
		Global.State.MAIN:
			$GridMenu.show()
			$ScrollContainer.hide()
			create_grid_buttons(Global.State.MAIN, main_buttons)
		Global.State.ATTACK:
			$GridMenu.show()
			$ScrollContainer.hide()
			create_attack_buttons()
		Global.State.SWAP:
			$GridMenu.hide()
			$ScrollContainer.show()
			create_swap_buttons()
		Global.State.ITEM:
			$GridMenu.hide()
			$ScrollContainer.show()
			create_item_buttons()
