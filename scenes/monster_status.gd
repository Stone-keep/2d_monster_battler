extends Control

func setup(is_player: bool):
	if is_player:
		$VBoxContainer/Label.text = Global.monster_data[Global.current_monster]["name"]
		$VBoxContainer/ProgressBar.max_value = Global.monster_data[Global.current_monster]["max health"]
		$VBoxContainer/ProgressBar.value = Global.monster_data[Global.current_monster]["max health"]
	else:
		$VBoxContainer/Label.text = Global.monster_data[Global.current_enemy]["name"]
		$VBoxContainer/ProgressBar.max_value = Global.monster_data[Global.current_enemy]["max health"]
		$VBoxContainer/ProgressBar.value = Global.monster_data[Global.current_enemy]["max health"]

func update(attack_damage):
	$VBoxContainer/ProgressBar.value -= attack_damage

func is_defeated():
	return $VBoxContainer/ProgressBar.value <= 0
