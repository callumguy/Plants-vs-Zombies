extends Node2D

@onready var SUN_FOLDER := get_node(LevelNodePaths.SUN_FOLDER_PATH)

@export var sun_scene: PackedScene
@export var drop_delay: float = 6.0
@export var sun_value: int = 50

var count: float
var spawn_y_level: int = -50

var enabled: bool = false

func _ready() -> void:
    count = drop_delay


func _process(delta: float) -> void:
    if not enabled:
        return
    count -= delta
    if count <= 0:
        count = drop_delay
        drop_delay += 0.1
        spawn()
        
func spawn() -> void:
    var sun = sun_scene.instantiate()
    sun.position = choose_spawn_loc()
    sun.sun_amount = sun_value
    
    sun.lane = randi_range(0, 4)
    sun.column = GameManager.get_grid_location(sun.position).y
    
    SUN_FOLDER.add_child(sun)
    
func choose_spawn_loc() -> Vector2:
    var x = randf_range(GameManager.LAWN_LEFT, GameManager.LAWN_LEFT + GameManager.LAWN_WIDTH)
    return Vector2(x, spawn_y_level)
