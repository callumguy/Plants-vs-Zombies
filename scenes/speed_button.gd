extends TextureButton

@onready var sped_up: bool = false
@onready var music_player = get_tree().current_scene.find_child("MusicPlayer")

var allow_speed_up := true

func _ready() -> void:
    self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
    if not allow_speed_up:
        return
    
    sped_up = !sped_up
    
    if sped_up:
        speed_up()
    else:
        slow_down()

func speed_up():
    Engine.time_scale = 2.0
    music_player.pitch_scale = 1.1
    
func slow_down():
    Engine.time_scale = 1.0
    music_player.pitch_scale = 1.0
