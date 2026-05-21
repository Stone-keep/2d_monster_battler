extends Control

@export var animation_index := 0:
	set(value):
		animation_index = value
		var atlas = $Monsters/EnemyMonster.texture as AtlasTexture
		atlas.region.position = Vector2(96 * animation_index, 0)

func _ready() -> void:
	player_monster_setup(Global.monsters[0])
	enemy_monster_setup(Global.enemy_monsters.pick_random())
	

func player_monster_setup(monster_name):
	Global.current_monster = monster_name
	$Monsters/PlayerMonster.texture = load(Global.monster_data[Global.current_monster]["back texture"])
	$Status/PlayerStatus.setup(true)

func enemy_monster_setup(monster_name):
	Global.current_enemy = monster_name
	var enemy_atlas: AtlasTexture = AtlasTexture.new()
	enemy_atlas.atlas = load(Global.monster_data[Global.current_enemy]["front texture"])
	enemy_atlas.region.size = Vector2(96, 96)
	$Monsters/EnemyMonster.texture = enemy_atlas
	$Status/EnemyStatus.setup(false)

func _on_input_menu_selected(state: int, type: Variant) -> void:
	match state:
		Global.State.ATTACK:
			var target = $Monsters/EnemyMonster if Global.attack_data[type]["target"] else $Monsters/PlayerMonster
			attack(target, type)
			swap_enemy_on_defeat()
			$InputMenu.current_state = Global.State.MAIN
		Global.State.SWAP:
			player_monster_setup(type)
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
	update_monster_stats(target, Global.attack_data[attack_type])

func swap_enemy_on_defeat():
	if $Status/EnemyStatus.is_defeated():
		Global.enemy_monsters.erase(Global.current_enemy)
		if len(Global.enemy_monsters) == 0:
			print("all monsters defeated, resetting")
			Global.enemy_monsters = Global.Monster.values()
		Global.current_enemy = Global.enemy_monsters.pick_random()
		enemy_monster_setup(Global.current_enemy)


func update_monster_stats(target, attack_data):
	if target == $Monsters/PlayerMonster:
		$Status/PlayerStatus.update(attack_data)
	else:
		$Status/EnemyStatus.update(attack_data)
