extends Node2D

@export var delay: float = 6.0
var count: float
@export var sun_scene: PackedScene
var spawn_y_level: int = -50

@export var sun_amount: int = 50

var enabled: bool = false

func _ready() -> void:
    count = delay


func _process(delta: float) -> void:
    if not enabled:
        return
    count -= delta
    if count <= 0:
        count = delay
        delay += 0.1
        spawn()
        
func spawn() -> void:
    var sun = sun_scene.instantiate()
    sun.position = choose_spawn_loc()
    sun.sun_amount = sun_amount
    
    sun.lane = randi_range(0, 4)
    sun.column = GameManager.get_grid_location(sun.position).y
    
    get_parent().find_child("SunFolder").add_child(sun)
    #add_child(sun)
    
func choose_spawn_loc() -> Vector2:
    var x = randf_range(GameManager.LAWN_LEFT, GameManager.LAWN_LEFT + GameManager.LAWN_WIDTH)
    return Vector2(x, spawn_y_level)
