extends Node2D

var RewardScene: PackedScene = preload("res://reward.tscn")

const REWARD_MENU_PATH := ScenePaths.REWARD_MENU
const MAIN_MENU_PATH := ScenePaths.MAIN_MENU 

@onready var ENEMY_MANAGER := get_node(LevelNodePaths.ENEMY_MANAGER_PATH)
@onready var SEED_BAR := get_node(LevelNodePaths.SEED_BAR_PATH)

@onready var announcements: CanvasLayer = $Announcements
@onready var music_player: AudioStreamPlayer = %MusicPlayer
@onready var music_player_seed_select: AudioStreamPlayer = $MusicPlayerSeedSelect
@onready var seed_select_menu: Control = $SeedSelectLayer/SeedSelectMenu
@onready var air_spawner: Node2D = $AirSpawner

var level_number: int
var level_reward_name: Variant
var level_seed_slots: int

var engine_speed_locked := true
var engine_is_sped_up := false

func _ready() -> void:
    
    level_number = LevelManager.level_number
    ENEMY_MANAGER.level_num = level_number
    
    level_reward_name = LevelData.get_level_info(level_number, 'reward')
    
    if LevelData.get_level_info(level_number, 'world') == LevelData.Worlds.DAY:
        $BackgroundDay.visible = true
    else:
        $BackgroundNight.visible = true
    
    get_tree().paused = false
    connections()
    
    level_seed_slots = LevelData.get_level_info(level_number, "seed_slots")
        
    if len(PlayerStats.plants_unlocked) > level_seed_slots:
        start_picking()
    else:
        SEED_BAR.fill(PlayerStats.plants_unlocked)
        start_battle()    
    
func connections() -> void:
    ENEMY_MANAGER.player_wins.connect(player_wins)
    ENEMY_MANAGER.player_loses.connect(player_loses)
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
    ENEMY_MANAGER.start_level()
    $PlacementManager.read_seedbar()
    if LevelData.get_level_info(level_number, 'world') != LevelData.Worlds.NIGHT:
        air_spawner.enabled = true
    engine_speed_locked = false
    
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
    
    slow_down_engine()
    engine_speed_locked = true
    
func player_loses(position: Vector2): # position of the zombie at the house (eating your brains)
    game_over()

func reward_clicked() -> void:
    music_player.stop()

func reward_collected() -> void:
    get_tree().change_scene_to_packed(load(REWARD_MENU_PATH))
    
func game_over():
    get_tree().change_scene_to_packed(load(MAIN_MENU_PATH)) # back to menu
    
func give_reward(reward: Variant) -> void:
    if reward == null:
        return
    
    var reward_dict = Rewards.split(reward)
    if reward_dict['type'] == "plant":
        PlayerStats.unlock_plant(reward_dict['name'])

func speed_up_engine() -> void:
    if engine_speed_locked:
        return
        
    Engine.time_scale = 2.0
    music_player.pitch_scale = 1.1

func slow_down_engine() -> void:
    if engine_speed_locked:
        return
        
    Engine.time_scale = 1.0
    music_player.pitch_scale = 1.0

func change_engine_speed() -> void:
    if engine_speed_locked:
        return
        
    engine_is_sped_up = !engine_is_sped_up
    if engine_is_sped_up:
        speed_up_engine()
    else:
        slow_down_engine()
