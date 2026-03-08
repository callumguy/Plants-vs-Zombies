extends VBoxContainer

@onready var packet_scene: PackedScene = preload("res://scenes/seed_packet.tscn")

func fill(plant_names: Array) -> void:
    #if len(seed_packets) != seed_slots: # not enough packets selected. or too many though that shouldnt be possible
    #    return
    
    for child in get_children():
        child.queue_free()
    
    # Create a battle_packet in SeedBar for each pickme_packet which is about to be deleted probably ig or just hidden actually
    for plant_name in plant_names:
        # var plant_name = packet.plant_name
        
        var packet = packet_scene.instantiate()
        packet.plant_name = plant_name
        add_child(packet)
    
    #emit_signal("ready_pressed")
