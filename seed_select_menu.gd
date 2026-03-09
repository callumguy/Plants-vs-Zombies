extends Control

signal ready_pressed

const SEED_PACKET := preload(ScenePaths.SEED_PACKET)

@onready var ready_button: Button = find_child("ReadyButton", true, false)
# @onready var seed_bar: VBoxContainer = get_tree().current_scene.find_child("LevelUI").find_child("SeedBar", true, true)
@onready var SEED_BAR := get_node(LevelNodePaths.SEED_BAR_PATH)

var seed_packets_picked: Array = []
var seed_slots: int = 5

func _ready() -> void:
    connections()
    create_packets()
    read_seeds()
    
    seed_slots = LevelData.get_level_info(LevelManager.level_number, "seed_slots")
    
func connections() -> void:
    ready_button.pressed.connect(_ready_pressed)
    
func read_seeds() -> void:
    for seed in find_child("GridContainer", true, true).get_children():
        seed.clicked.connect(_seed_clicked)
        
func _seed_clicked(seed_packet) -> void:
    if not seed_packet.is_picked and len(seed_packets_picked) >= seed_slots:
        return # Can't pick another seed -- Seed slots are full
    
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    seed_packet.is_picked = not seed_packet.is_picked
    var tween = create_tween()
    
    if seed_packet.is_picked: # Pick it
        seed_packets_picked.append(seed_packet)
        tween.tween_property(seed_packet, "global_position", SEED_BAR.get_child(len(seed_packets_picked) - 1).global_position, 0.1)
    else: # Unpick it
        var index = seed_packets_picked.find(seed_packet)
        
        for packet in seed_packets_picked:
            if seed_packets_picked.find(packet) > index:
                create_tween().tween_property(packet, "global_position", SEED_BAR.get_child(seed_packets_picked.find(packet) - 1).global_position, 0.05)
            
        seed_packets_picked.erase(seed_packet)
        tween.tween_property(seed_packet, "global_position", seed_packet.menu_pos, 0.1)
        
            

    print(seed_packets_picked)
    
    await tween.finished
    mouse_filter = Control.MOUSE_FILTER_STOP

func _ready_pressed() -> void:
    if len(seed_packets_picked) != seed_slots: # not enough packets selected. or too many though that shouldnt be possible
        return
        
    var plant_names = seed_packets_picked.map(func(x): return x.plant_name)
    SEED_BAR.fill(plant_names)
    emit_signal("ready_pressed")


func create_packets() -> void:
    var plants_unlocked = PlayerStats.plants_unlocked
    for plant in plants_unlocked:
        var packet = SEED_PACKET.instantiate()
        packet.set_script(load("res://pickme_packet.gd"))
        packet.plant_name = plant
        $PanelContainer/VBoxContainer/GridContainer.add_child(packet)
