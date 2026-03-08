extends TextureRect

var BAR_LENGTH: int = (texture.region.size.x - 16) / 2 # 8 grey pixels on each side so -16, idk why i need to divide by 2 but it works
var flag_scene: PackedScene = preload("res://flag_icon.tscn")

@onready var progress_chunk: TextureRect = $ProgressChunk
@onready var zombie_face: TextureRect = $ZombieFace

func fraction_to_distance(current_progress: int, max_progress: int):
    var progress = float(current_progress) / max_progress 
    var progressChunkLength = BAR_LENGTH * progress * -1
    return progressChunkLength


func make_progress(spawned_waves: int, total_waves: int) -> void:
    var bar_current_length = fraction_to_distance(spawned_waves, total_waves)
    progress_chunk.scale.x = bar_current_length
    zombie_face.position.x = progress_chunk.position.x + (bar_current_length * 2) - (zombie_face.texture.region.size.x / 2)
    
    if progress_chunk.scale.x != 0:
        progress_chunk.visible = true
        zombie_face.visible = true
    else:
        progress_chunk.visible = false # this line will never ever run probably
        zombie_face.visible = false


func create_flag(wave: int, total_waves: int) -> void:
    print(str(wave) + " " + str(total_waves))
    var shift = fraction_to_distance(wave, total_waves) * 2
    var flag_icon = flag_scene.instantiate()
        
    add_child(flag_icon)
    
    flag_icon.position = progress_chunk.position
    flag_icon.position.x += shift
        
