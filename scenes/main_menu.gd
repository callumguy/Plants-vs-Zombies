extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/Play
@onready var settings_button: Button = $MarginContainer/VBoxContainer/Settings
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Quit

@onready var settings_menu: CanvasLayer = $SettingsMenu

@onready var level_select_scene = preload("res://levels_menu.tscn")
# @onready var level_scene = preload("res://scenes/level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    play_button.pressed.connect(play)
    settings_button.pressed.connect(settings)
    quit_button.pressed.connect(quit)
    
    
func play():
    print("play!")
    get_tree().change_scene_to_packed(level_select_scene)
    
func settings():
    settings_menu.visible = true
    
func quit():
    get_tree().quit()
