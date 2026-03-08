extends RigidBody2D

@onready var currency: Currency = get_tree().current_scene.find_child("CurrencyComponent")

var max_fall_speed := 40.0

var lane: int
var column: int
var sun_amount: int = 50

var collected: bool = false

func _ready():
    collision_mask = 1 << (lane + 9 - 1)
    freeze = false

func spawn_movement() -> void: # this function is called only when sunflowers make the sun.
    apply_impulse(Vector2(randf_range(-120, 120), -240))
    max_fall_speed = 80.0

func collect():
    if collected:
        return
    collected = true
    
    input_pickable = false
    freeze = true
    currency.add(sun_amount)
    
    var tween_time := 0.3
    var tween := create_tween()
    tween.tween_property(
        self,
        "global_position",
        Vector2(50, 50),
        tween_time
    ).set_ease(Tween.EASE_IN)
    
    await get_tree().create_timer(tween_time).timeout
    queue_free()

func _physics_process(delta: float) -> void:
    if linear_velocity.y > max_fall_speed:
        linear_velocity.y = max_fall_speed
    #print("-" + str(collision_mask))

func _on_click_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        collect()
    
    if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        collect()
