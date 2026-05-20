extends Control


func _ready() -> void:
	Global.current_monster = Global.monsters[0]

func _on_input_menu_selected(state: int, type: Variant) -> void:
	match state:
		Global.State.ATTACK:
			var target = $Monsters/EnemyMonster if Global.attack_data[type]["target"] else $Monsters/PlayerMonster
			attack(target, type)

func attack(target: TextureRect, attack_type: Global.Attack):
	var attack_position
	if target == $Monsters/PlayerMonster:
		attack_position = $Monsters/PlayerMonster/AttackPosition.global_position
		$AttackSprite.scale = Vector2(4.0, 4.0)
	else:
		attack_position = $Monsters/EnemyMonster/AttackPosition.global_position
		$AttackSprite.scale = Vector2(2.5, 2.5)
	$AttackSprite.global_position = attack_position
	$AttackSprite.show()
	$AttackSprite.texture = load(Global.attack_data[attack_type]["animation"])
	$AttackSprite.frame = 0
	var animation_tween = create_tween()
	animation_tween.tween_property($AttackSprite, "frame", 3, 0.4).from(0)
	animation_tween.tween_property($AttackSprite, "visible", false, 0.0)
