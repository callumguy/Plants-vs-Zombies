extends Control

@onready var main_menu_scene: PackedScene = load("res://scenes/main_menu.tscn")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var settings_menu: CanvasLayer = $SettingsMenu

@onready var resume_b: Button = $PanelContainer/VBoxContainer/Resume
@onready var restart_b: Button = $PanelContainer/VBoxContainer/Restart

@onready var settings_b: Button = $PanelContainer/VBoxContainer/Settings
@onready var main_menu_b: Button = $"PanelContainer/VBoxContainer/Main Menu"

func _ready() -> void:
    resume_b.pressed.connect(resume)
    restart_b.pressed.connect(restart)
    settings_b.pressed.connect(_on_settings_pressed)
    main_menu_b.pressed.connect(_on_main_menu_pressed)

func pause():
    get_tree().paused = true
    visible = true
    audio_stream_player.play()
    
func resume():
    get_tree().paused = false
    visible = false

func restart():
    get_tree().reload_current_scene()

func _on_resume_pressed() -> void:
    resume()

func _on_restart_pressed() -> void:
    restart()

func _on_settings_pressed() -> void:
    settings_menu.visible = true

func _on_main_menu_pressed() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_packed(main_menu_scene)

func testEsc():
    if Input.is_action_just_pressed("Escape"): 
        if get_tree().paused == false:
            pause()
        else:
            resume()
    
func _process(delta: float) -> void:
    testEsc()
