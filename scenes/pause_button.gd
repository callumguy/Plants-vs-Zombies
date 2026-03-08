extends TextureButton

@onready var pause_menu = get_tree().root.find_child("PauseMenu", true, false)

func _ready() -> void:
    self.pressed.connect(_on_pressed)
    
func _on_pressed() -> void:
    pause_menu.pause()
    
