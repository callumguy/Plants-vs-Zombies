extends TextureButton

const MAIN_MENU_PATH := ScenePaths.MAIN_MENU

func _ready() -> void:
    self.pressed.connect(_pressed)
    
func _pressed() -> void:
    if get_tree() == null:
        return
    
    get_tree().change_scene_to_packed(load(MAIN_MENU_PATH))
