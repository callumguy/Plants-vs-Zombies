extends CanvasLayer

@export var display_mode_selector: OptionButton
@export var resolution_selector: OptionButton

@export var master_volume_scrollbar: HScrollBar
@export var music_volume_scrollbar: HScrollBar
@export var sfx_volume_scrollbar: HScrollBar
@export var close_button: Button

const CONFIG_PATH = "user://settings.cfg"

func _ready() -> void:
    display_mode_selector.item_selected.connect(change_display_mode)
    resolution_selector.item_selected.connect(change_resolution)
    
    master_volume_scrollbar.value_changed.connect(change_master_volume)
    music_volume_scrollbar.value_changed.connect(change_music_volume)
    sfx_volume_scrollbar.value_changed.connect(change_sfx_volume)
    close_button.pressed.connect(close_settings_menu)
    
    load_settings()
    
func load_settings():
    var cfg = ConfigFile.new()
    var err = cfg.load(CONFIG_PATH)
    if err != OK:
        return
    
    master_volume_scrollbar.value = cfg.get_value("audio", "master_volume", 1.0)
    music_volume_scrollbar.value = cfg.get_value("audio", "music_volume", 1.0)
    sfx_volume_scrollbar.value = cfg.get_value("audio", "sfx_volume", 1.0)
    apply_volume()
    
    display_mode_selector.selected = cfg.get_value("display", "mode", 0)
    resolution_selector.selected = cfg.get_value("display", "resolution", 0)
    apply_display()
    
func apply_volume() -> void:
    AudioManager.update_volume(AudioManager.VolumeChannel.MASTER, master_volume_scrollbar.value)
    AudioManager.update_volume(AudioManager.VolumeChannel.MUSIC, music_volume_scrollbar.value)
    AudioManager.update_volume(AudioManager.VolumeChannel.SFX, sfx_volume_scrollbar.value)

func apply_display() -> void:
    change_display_mode(display_mode_selector.selected)
    change_resolution(display_mode_selector.selected)

func save_settings() -> void:
    var cfg = ConfigFile.new()
    cfg.load(CONFIG_PATH)
    
    cfg.set_value("audio", "master_volume", master_volume_scrollbar.value)
    cfg.set_value("audio", "music_volume",  music_volume_scrollbar.value)
    cfg.set_value("audio", "sfx_volume",    sfx_volume_scrollbar.value)
    
    cfg.set_value("display", "mode", display_mode_selector.selected)
    cfg.set_value("display", "resolution", resolution_selector.selected)
    
    cfg.save(CONFIG_PATH)

func change_master_volume(new_value) -> void:
    AudioManager.update_volume(AudioManager.VolumeChannel.MASTER, new_value)
    save_settings()
    
func change_music_volume(new_value) -> void:
    AudioManager.update_volume(AudioManager.VolumeChannel.MUSIC, new_value)
    save_settings()
    
func change_sfx_volume(new_value) -> void:
    AudioManager.update_volume(AudioManager.VolumeChannel.SFX, new_value)
    save_settings()


func set_display_mode(mode) -> void:
    DisplayServer.window_set_mode(mode)
    save_settings()

func change_display_mode(index: int) -> void:
    match index:
        0: set_display_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        1: set_display_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        2: set_display_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_resolution(w: int, h: int) -> void:
    DisplayServer.window_set_size(Vector2i(w, h))
    save_settings()

func change_resolution(index: int) -> void:
    match index:
        0: set_resolution(1280, 720)
        1: set_resolution(1600, 900)
        2: set_resolution(1920, 1080)  
    
func close_settings_menu() -> void:
    visible = false
    
