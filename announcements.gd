extends CanvasLayer

@onready var texturerect: TextureRect = $Control/TectureRect

@onready var thump_sound: AudioStreamPlayer = $ThumpSound
@onready var final_wave_sound: AudioStreamPlayer = $FinalWaveSound
@onready var huge_wave_sound: AudioStreamPlayer = $HugeWaveSound


const fade_duration: float = 0.1

const text_ready = preload("res://assets/announcements/StartReady.png")
const text_set = preload("res://assets/announcements/StartSet.png")
const text_plant = preload("res://assets/announcements/StartPlant.png")
const text_finalwave = preload("res://assets/announcements/FinalWave.png")

var textures: Dictionary = {
    0: text_ready,
    1: text_set,
    2: text_plant,
    3: text_finalwave
}

func show_message_index(idx: int, duration: float) -> void: # Ready, Set, Plant, Final Wave
    match idx:
        0: 
            thump_sound.play()
        3:
            final_wave_sound.play()
    
    
    texturerect.texture = textures[idx]
    
    texturerect.pivot_offset = texturerect.size / 2
    
    texturerect.visible = true
    texturerect.modulate.a = 0
    texturerect.scale = Vector2(1, 1)
    
    var tween_alpha = create_tween()
    tween_alpha.tween_property(texturerect, "modulate:a", 1.0, fade_duration)
    if idx in [0, 1]:
        var tween_scale = create_tween()
        tween_scale.tween_property(texturerect, "scale", Vector2(1.1, 1.1), duration)
    
    await get_tree().create_timer(duration - fade_duration).timeout
    
    tween_alpha = create_tween()
    tween_alpha.tween_property(texturerect, "modulate:a", 0.0, fade_duration)
    
    await tween_alpha.finished
    texturerect.visible = false
    
func _ready() -> void:
    pass
