extends Node

enum VolumeChannel {master, music, SFX}

func update_volume(channel: VolumeChannel, new_value: float) -> void:
    var bus = null
    if channel == VolumeChannel.master:
        bus = AudioServer.get_bus_index("Master")
    elif channel == VolumeChannel.music:
        bus = AudioServer.get_bus_index("Music")
    elif channel == VolumeChannel.SFX:
        bus = AudioServer.get_bus_index("SFX")
        
    if new_value == 0:
        AudioServer.set_bus_mute(bus, true)
    else:
        AudioServer.set_bus_mute(bus, false)
        AudioServer.set_bus_volume_db(bus, linear_to_db(new_value))
