extends Control

@onready var monster_name: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var health_bar: TextureProgressBar = $PanelContainer/MarginContainer/VBoxContainer/ProgressBar

func setup(is_player: bool):
	if is_player:
		monster_name.text = Global.monster_data[Global.current_monster]["name"]
		health_bar.max_value = Global.monster_data[Global.current_monster]["max health"]
		health_bar.value = Global.monster_data[Global.current_monster]["max health"]
	else:
		monster_name.text = Global.monster_data[Global.current_enemy]["name"]
		health_bar.max_value = Global.monster_data[Global.current_enemy]["max health"]
		health_bar.value = Global.monster_data[Global.current_enemy]["max health"]

func update(attack_damage):
	health_bar.value -= attack_damage

func is_defeated():
	return health_bar.value <= 0
