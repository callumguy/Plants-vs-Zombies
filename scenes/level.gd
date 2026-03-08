extends Node2D

var RewardScene: PackedScene = preload("res://reward.tscn")
var RewardMenuScene: PackedScene = preload("res://reward_menu.tscn")

@onready var main_menu_scene: PackedScene = load("res://scenes/main_menu.tscn")
@onready var enemy_manager: Node2D = $EnemyManager
@onready var announcements: CanvasLayer = $Announcements
@onready var music_player: AudioStreamPlayer = %MusicPlayer
@onready var music_player_seed_select: AudioStreamPlayer = $MusicPlayerSeedSelect
@onready var seed_select_menu: Control = $SeedSelectLayer/SeedSelectMenu
@onready var air_spawner: Node2D = $AirSpawner

var level_number: int
var level_reward_name: Variant
var level_seed_slots: int

func _ready() -> void:
    level_number = LevelManager.level_number
    enemy_manager.level_num = level_number
    
    level_reward_name = LevelData.get_level_info(level_number, 'reward')
    
    get_tree().paused = false
    connections()
    
    level_seed_slots = LevelData.get_level_info(level_number, "seed_slots")
        
    if len(PlayerStats.plants_unlocked) > level_seed_slots:
        start_picking()
    else:
        $CanvasLayer/LevelUI/MarginContainer/HBoxContainer/LeftBar/SeedBar.fill(PlayerStats.plants_unlocked)
        start_battle()    
    
func connections() -> void:
    enemy_manager.player_wins.connect(player_wins)
    enemy_manager.player_loses.connect(player_loses)
    seed_select_menu.ready_pressed.connect(start_battle)
    
func start_picking() -> void:
    seed_select_menu.visible = true
    music_player_seed_select.play()

func start_battle():
    seed_select_menu.visible = false
    await announcements.show_message_index(0, 0.75)
    await announcements.show_message_index(1, 0.75)
    await announcements.show_message_index(2, 1)
    music_player_seed_select.stop()
    music_player.play()
    enemy_manager.start_level()
    $PlacementManager.read_seedbar()
    air_spawner.enabled = true
    
func player_wins(position: Vector2) -> void: # position of the last zombie (that just died)
    var reward_scene: RigidBody2D = RewardScene.instantiate()
    reward_scene.reward = level_reward_name
    
    reward_scene.clicked.connect(reward_clicked)
    reward_scene.collected.connect(reward_collected)
    reward_scene.position = position
    
    var lane = int(GameManager.get_grid_location(position).y)
    reward_scene.collision_mask = 1 << (lane + 9 - 1)
    
    add_child(reward_scene)
    give_reward(level_reward_name)
    
    if level_number > PlayerStats.high_level:
        PlayerStats.level_up()
    
    var speed_button = find_child("LevelUI").find_child("SpeedButton")
    speed_button.allow_speed_up = false
    speed_button.slow_down()
    
func player_loses(position: Vector2): # position of the zombie at the house (eating your brains)
    game_over()

func reward_clicked() -> void:
    music_player.stop()

func reward_collected() -> void:
    get_tree().change_scene_to_packed(RewardMenuScene)
    
func game_over():
    get_tree().change_scene_to_packed(main_menu_scene) # back to menu
    
func give_reward(reward: Variant) -> void:
    if reward == null:
        return
    
    var reward_dict = Rewards.split(reward)
    if reward_dict['type'] == "plant":
        PlayerStats.unlock_plant(reward_dict['name'])
