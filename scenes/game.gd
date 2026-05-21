extends Control

@export var animation_index := 0:
	set(value):
		animation_index = value
		var atlas = $Monsters/EnemyMonster.texture as AtlasTexture
		atlas.region.position = Vector2(96 * animation_index, 0)

func _ready() -> void:
	# Player Monster Setup
	Global.current_monster = Global.monsters[0]
	$Monsters/PlayerMonster.texture = load(Global.monster_data[Global.current_monster]["back texture"])

	# Enemy Monster Setup
	Global.current_enemy = Global.Monster.values().pick_random()
	var enemy_atlas: AtlasTexture = AtlasTexture.new()
	enemy_atlas.atlas = load(Global.monster_data[Global.current_enemy]["front texture"])
	enemy_atlas.region.size = Vector2(96, 96)
	$Monsters/EnemyMonster.texture = enemy_atlas

func _on_input_menu_selected(state: int, type: Variant) -> void:
	match state:
		Global.State.ATTACK:
			var target = $Monsters/EnemyMonster if Global.attack_data[type]["target"] else $Monsters/PlayerMonster
			attack(target, type)
			$InputMenu.current_state = Global.State.MAIN
		Global.State.SWAP:
			Global.current_monster = type
			$Monsters/PlayerMonster.texture = load(Global.monster_data[type]["back texture"])
			$InputMenu.current_state = Global.State.MAIN

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
