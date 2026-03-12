extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/Play
@onready var settings_button: Button = $MarginContainer/VBoxContainer/Settings
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Quit

@onready var settings_menu: CanvasLayer = $SettingsMenu

const LEVEL_SELECT_MENU_PATH = ScenePaths.LEVEL_SELECT_MENU

func _ready() -> void:
    play_button.pressed.connect(play)
    settings_button.pressed.connect(settings)
    quit_button.pressed.connect(quit)
    
    # ReanimParser2.ready()
    
func play():
    get_tree().change_scene_to_packed(load(LEVEL_SELECT_MENU_PATH))
    
func settings():
    settings_menu.visible = true
    
func quit():
    get_tree().quit()
