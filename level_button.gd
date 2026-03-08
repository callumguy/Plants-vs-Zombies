extends Button

@export var level_number: int = 1

func _ready() -> void:
    connections()
    
    text = "Level " + str(level_number)
    if PlayerStats.high_level + 1 < level_number:
        text = "Locked"
        add_theme_color_override("font_color", Color.DIM_GRAY)
        
    if PlayerStats.high_level >= level_number:
        add_theme_color_override("font_color", Color.GREEN)
    
    
func connections():
    self.pressed.connect(_pressed, CONNECT_ONE_SHOT)
    
    
func _pressed() -> void:
    if get_tree() == null:
        return
    
    if level_number > PlayerStats.high_level + 1: # player can access levels 1 higher than their high level. if their high_level is 4 they can play level 5.
        return
    
    LevelManager.level_number = level_number
    get_tree().change_scene_to_packed(LevelManager.level_packed_scene)
    queue_free()
    
    
    #level_scene.find_child("EnemyManager").level_num = level_number
    
    #get_tree().root.call_deferred("add_child", level_scene)
    #get_tree().current_scene.queue_free()
    # 
    #get_tree().current_scene = level_scene
