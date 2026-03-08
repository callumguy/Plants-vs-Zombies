extends Node2D

signal player_wins(zombie_position: Vector2)
signal player_loses(zombie_position: Vector2)

@onready var groan_player: AudioStreamPlayer = $GroanPlayer
@onready var progress_bar: TextureRect = $"../CanvasLayer/LevelUI/MarginContainer/HBoxContainer/TopBar/ProgressBar"

@export var spawn_x := 1100
@export var level_num := 1
@export var wave_interval := 60.0

var game_over := false
var next_wave: int
var total_waves: int
var waves_healthpools: Dictionary = {}

var level_waves: Array
var time_count: float

var previous_zombie_death_pos: Vector2


func _process(delta: float) -> void:
    if not level_waves or game_over:
        return
        
    if next_wave > total_waves: # once all waves have spawned, keep checking if the player has won
        if check_for_win():
            game_over = true
            player_wins.emit(previous_zombie_death_pos)
        return
    
    time_count += delta
    if time_count >= wave_interval: # time count is increased a lot when the wave of zombies before take half of their healthpool of damage
        time_count = 0
        send_wave(level_waves[next_wave - 1])
        progress_bar.make_progress(next_wave, total_waves)
        next_wave += 1
        
func start_level():
    next_wave = 1
    level_waves = get_waves(level_num)
    total_waves = len(level_waves)


func get_waves_old(level_num: int) -> Array:
    var file_name = "level_"+str(level_num)+".txt"
    var file = FileAccess.open("levels/"+file_name, FileAccess.READ)

    if not file:
        return []
    var waves = []
    
    while not file.eof_reached():
        var current_wave = {flag = false, zombies = []}
        var line = file.get_line()
        
        if line.is_empty() or line.begins_with('#'): # Ignore empty lines
            continue
        
        if line.begins_with("FLAG"): 
            current_wave[0]['flag'] = true
            line.trim_prefix("FLAG")
        
        for zombie_data in line.split(" + "):
            var split_zombie_data = zombie_data.split("*")
            var zombie_type = split_zombie_data[0]
            
            var zombie_amount = 1
            if len(split_zombie_data) > 1: # if there is an amount use that instead
                zombie_amount = int(split_zombie_data[1])
            
            for i in range(0, zombie_amount):
                current_wave['zombies'].append(zombie_type)
            
        waves.append(current_wave)
    return waves


func get_waves(level_num: int) -> Array:
    var file_name = "level_"+str(level_num)+".txt"
    var file = FileAccess.open("levels/"+file_name, FileAccess.READ)

    if not file:
        return []
    var waves = []
    
    while not file.eof_reached():
        var current_wave = {flag = false, zombies = []}
        var line = file.get_line()
        
        if line.is_empty() or line.begins_with('#'): # Ignore empty lines
            continue
        
        if line.begins_with("FLAG"): 
            current_wave['flag'] = true
            line.trim_prefix("FLAG")
        
        var zombie_pool = ["basic", "conehead", "buckethead"]
        var wave_cost = int(line)
        
        while wave_cost > 0:
            var random_zombie = zombie_pool.pick_random() 
            if ZombieData.zombies[random_zombie]['cost'] <= wave_cost:
                current_wave['zombies'].append(random_zombie)
                wave_cost -= ZombieData.zombies[random_zombie]['cost']
            else:
                zombie_pool.erase(random_zombie)

        waves.append(current_wave)
    
    var i := 0
    for wave in waves:
        i += 1
        if wave['flag'] == true:
            progress_bar.create_flag(i, len(waves))
        
    return waves

func send_wave(wave: Dictionary) -> void:
    var wave_zombies = wave['zombies']
    var lanes = range(0, GameManager.number_of_lanes)
    wave_zombies.shuffle()
    # lanes.shuffle()
    
    for zombie_name in wave_zombies:
        var lane = lanes.pick_random()
        spawn_enemy(lane, zombie_name)
    
    groan_player.play()
    if not progress_bar.visible:
        progress_bar.visible = true
    
    if wave['flag']:
        get_parent().announcements.show_message_index(3, 2)
        
    
func get_zombie_scene_from_name_old(zombie_name: String):
    var zombie_scene_file = "scenes/zombies/zombie_" + zombie_name + ".tscn"
    var zombie_scene = load(zombie_scene_file)
    
    return zombie_scene
    
func get_zombie_scene_from_name(zombie_name: String):
    #var zombie_scene_file = "scenes/zombies/zombie_" + zombie_name + ".tscn"
    var zombie_scene = ZombieData.zombies[zombie_name]['scene']
    return zombie_scene

func spawn_enemy(lane: int, zombie_name: String):
    var enemy = ZombieData.zombies[zombie_name]['scene'].instantiate()
    enemy.lane = lane
    enemy.wave = next_wave - 1
    
    if not str(next_wave - 1) in waves_healthpools:
        waves_healthpools[str(next_wave - 1)] = {'current': 0, 'max': 0}
    
    waves_healthpools[str(next_wave - 1)]['current'] += ZombieData.zombies[zombie_name]['health']
    waves_healthpools[str(next_wave - 1)]['max'] += ZombieData.zombies[zombie_name]['health']
    
    var lane_y = GameManager.LAWN_TOP + (GameManager.CELL_HEIGHT * lane + GameManager.CELL_HEIGHT / 2)
    var x = randi_range(spawn_x - 10, spawn_x + 10)
    enemy.position = Vector2(x, lane_y)
 
    get_parent().call_deferred("add_child", enemy)
    
    enemy.zombie_at_house.connect(_zombie_at_house)
    enemy.zombie_died.connect(_zombie_died)
    enemy.damaged.connect(_zombie_damaged)
    
func _zombie_at_house(zombie_position: Vector2):
    if not game_over:
        game_over = true
        player_loses.emit(zombie_position)

func _zombie_damaged(zombie, damage_taken: int) -> void:
    waves_healthpools[str(zombie.wave)]['current'] -= damage_taken
    if waves_healthpools[str(zombie.wave)]['current'] <= waves_healthpools[str(zombie.wave)]['max'] / 2:
        if zombie.wave == next_wave - 2:
            time_count += 1000.0
        
func _zombie_died(zombie_position: Vector2):
    previous_zombie_death_pos = zombie_position

func check_for_win():
    if not next_wave > total_waves: # If not all waves have spawned, player hasn't won. Return false
        return false 

    var zombies_remaining: int = get_tree().get_nodes_in_group("zombies").size()
    if zombies_remaining > 0: # If there are zombies are alive player hasn't won. Return false
        return false
        
    return true # player wins!!!!
    
    
        
        
        
        
            
            
            
    
