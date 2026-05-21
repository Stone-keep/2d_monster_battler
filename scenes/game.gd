extends Control

@export var animation_index := 0:
	set(value):
		animation_index = value
		var atlas = $Monsters/EnemyMonster.texture as AtlasTexture
		atlas.region.position = Vector2(96 * animation_index, 0)

var enemy_can_move := true
var player_is_defending := false

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
		Global.State.SWAP:
			player_monster_setup(type)
		Global.State.DEFEND:
			player_is_defending = true
		Global.State.ITEM:
			use_item(type)
			swap_enemy_on_defeat()
	$InputMenu.hide()
	$Monsters/EnemyMonster/EnemyTurnTimer.start()

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
	update_monster_stats(target, Global.attack_data[attack_type]["amount"])

func swap_enemy_on_defeat():
	if $Status/EnemyStatus.is_defeated():
		enemy_can_move = false
		Global.enemy_monsters.erase(Global.current_enemy)
		if len(Global.enemy_monsters) == 0:
			print("all enemy monsters defeated, resetting")
			Global.enemy_monsters = Global.Monster.values()
		Global.current_enemy = Global.enemy_monsters.pick_random()
		enemy_monster_setup(Global.current_enemy)
		$DefeatLabel.text = "Enemy Monster Defeated\n%s Appears!" % Global.monster_data[Global.current_enemy]["name"]
		$DefeatLabel.show()

func swap_player_on_defeat() -> bool:
	if $Status/PlayerStatus.is_defeated():
		Global.monsters.erase(Global.current_monster)
		if len(Global.monsters) == 0:
			print("all player monsters defeated, resetting")
			Global.monsters = Global.Monster.values()
		Global.current_monster = Global.monsters[0]
		player_monster_setup(Global.current_monster)
		$DefeatLabel.text = "Player Monster Defeated\nGo %s!" % Global.monster_data[Global.current_monster]["name"]
		$DefeatLabel.show()
		return true
	return false

func use_item(item):
	var target = $Monsters/EnemyMonster if Global.item_data[item]["target"] else $Monsters/PlayerMonster
	update_monster_stats(target, Global.item_data[item]["amount"])

func update_monster_stats(target, amount):
	if target == $Monsters/PlayerMonster:
		if player_is_defending:
			$Status/PlayerStatus.update(floori(amount / 2))
		else:
			$Status/PlayerStatus.update(amount)
	else:
		$Status/EnemyStatus.update(amount)

func _on_enemy_turn_timer_timeout() -> void:
	var player_was_defeated := false
	if enemy_can_move:
		var attack_type = Global.monster_data[Global.current_enemy]["attacks"].pick_random()
		var target = $Monsters/PlayerMonster if Global.attack_data[attack_type]["target"] else $Monsters/EnemyMonster
		attack(target, attack_type)
		player_was_defeated = swap_player_on_defeat()
	enemy_can_move = true
	player_is_defending = false
	if player_was_defeated:
		$InputMenu/MenuTimer.start(2.5)
	else:
		$InputMenu/MenuTimer.start(1.0)

func _on_menu_timer_timeout() -> void:
	$DefeatLabel.hide()
	$InputMenu.show()

func _on_input_menu_visibility_changed() -> void:
	$InputMenu.current_state = Global.State.MAIN
