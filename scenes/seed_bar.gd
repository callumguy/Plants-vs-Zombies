extends VBoxContainer

const SEED_PACKET := preload(ScenePaths.SEED_PACKET)

func fill(plant_names: Array) -> void:
    #if len(seed_packets) != seed_slots: # not enough packets selected. or too many though that shouldnt be possible
    #    return
    
    for child in get_children():
        child.queue_free()
    
    # Create a battle_packet in SeedBar for each pickme_packet which is about to be deleted probably ig or just hidden actually
    for plant_name in plant_names:
        # var plant_name = packet.plant_name
        
        var packet = SEED_PACKET.instantiate()
        packet.plant_name = plant_name
        add_child(packet)
    
    #emit_signal("ready_pressed")

func _ready() -> void:
    var empty_slot: TextureRect = get_parent().get_parent().get_parent().get_parent().find_child("EmptySlot")
    for i in range(LevelData.get_level_info(LevelManager.level_number, 'seed_slots')):
        print("yuh")
        var empty_slot_copy = empty_slot.duplicate()
        add_child(empty_slot_copy)
        empty_slot_copy.visible = true
