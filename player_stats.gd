extends Node

const CONFIG_PATH = "user://stats.cfg"

var high_level: int
var plants_unlocked: Array


func _ready() -> void:
    load_stats()
    print(high_level)
    print(plants_unlocked)

func load_stats() -> void:
    var cfg = ConfigFile.new()
    var err = cfg.load(CONFIG_PATH)
    #if err != OK:
    #    return
        
    high_level = cfg.get_value("progress", "high_level", 0)
    plants_unlocked = cfg.get_value("progress", "plants_unlocked", ["peashooter", "sunflower", "wallnut"])

    
func save_stats() -> void:
    var cfg = ConfigFile.new()
    cfg.load(CONFIG_PATH)
    
    cfg.set_value("progress", "high_level", high_level)
    cfg.set_value("progress", "plants_unlocked", plants_unlocked)
    
    cfg.save(CONFIG_PATH)


func level_up() -> void:
    high_level += 1
    save_stats()
    
func unlock_plant(plant_name: String) -> void:
    if not plant_name in plants_unlocked:
        plants_unlocked.append(plant_name)
        save_stats()
