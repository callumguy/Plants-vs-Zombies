extends TextureButton

var main_menu_scene: PackedScene

func _ready() -> void:
    main_menu_scene = preload("res://scenes/main_menu.tscn")
    self.pressed.connect(_pressed)
    
func _pressed() -> void:
    if get_tree() == null:
        return
    
    get_tree().change_scene_to_packed(main_menu_scene)
