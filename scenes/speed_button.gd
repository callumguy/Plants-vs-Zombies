extends TextureButton

@onready var LEVEL := get_node(LevelNodePaths.LEVEL_PATH)
@onready var music_player = get_tree().current_scene.find_child("MusicPlayer")

func _ready() -> void:
    self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
    LEVEL.change_engine_speed()
