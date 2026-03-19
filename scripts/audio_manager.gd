extends Node
enum VolumeChannel {MASTER, MUSIC, SFX}

const MAX_SFX_PLAYERS: int = 8
var _sfx_player_pool: Array[AudioStreamPlayer] = []

@onready var music_player: AudioStreamPlayer = $MusicPlayer

static func update_volume(channel: VolumeChannel, new_value: float) -> void:
    var bus = null
    if channel == VolumeChannel.MASTER:
        bus = AudioServer.get_bus_index("Master")
    elif channel == VolumeChannel.MUSIC:
        bus = AudioServer.get_bus_index("Music")
    elif channel == VolumeChannel.SFX:
        bus = AudioServer.get_bus_index("SFX")
        
    if new_value == 0:
        AudioServer.set_bus_mute(bus, true)
    else:
        AudioServer.set_bus_mute(bus, false)
        AudioServer.set_bus_volume_db(bus, linear_to_db(new_value))

func play_music(track_name: String) -> void:
    music_player["parameters/switch_to_clip"] = track_name.to_lower()
    music_player.playing = true

func stop_music():
    music_player["parameters/switch_to_clip"] = null # not necesasrryfsdfsdf
    music_player.playing = false
    
func _ready() -> void:
    for i in MAX_SFX_PLAYERS:
        var player = AudioStreamPlayer.new()
        add_child(player)
        _sfx_player_pool.append(player)
        
func _get_free_sfx_player() -> AudioStreamPlayer:
    for player in _sfx_player_pool:
        if not player.playing:
            return player
    return null
    
func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
    var player = _get_free_sfx_player()
    if not player: return
    player.stream = stream
    player.volume_db = volume_db
    player.play()
    

    
