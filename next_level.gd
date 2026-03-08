extends TextureButton

var next_level_number: int

func _ready() -> void:
    self.pressed.connect(_pressed)
    if not there_is_a_next_level():
        visible = false
        
func _pressed() -> void:
    if get_tree() == null:
        return
    
    if there_is_a_next_level():
        LevelManager.level_number += 1
        get_tree().change_scene_to_packed(LevelManager.level_packed_scene)

func there_is_a_next_level() -> bool:
    var next_level_number = LevelManager.level_number + 1
    if str(next_level_number) in LevelData.levels:
        return true
    else:
        return false
