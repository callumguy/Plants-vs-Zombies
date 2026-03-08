extends RigidBody2D

signal clicked
signal collected

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var win_music: AudioStreamPlayer = $WinMusic

var reward
#enum reward_types {PLANT, OTHER}
#var reward_type

func _ready() -> void:
    sprite_2d.scale = Vector2(0.75, 0.75)
    input_event.connect(_on_input_event)
    set_texture(reward)
    
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        _collect()
        
func _collect() -> void:
    win_music.play()
    clicked.emit()
    
    input_pickable = false
    freeze = true
    
    var scale_tween = create_tween()
    scale_tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    
    var tween = create_tween()
    tween.tween_property(self, "global_position", Vector2(GameManager.window_width / 2, GameManager.window_height / 2), 4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    
    await scale_tween.finished
    collected.emit()

func set_texture(reward: Variant) -> void:
    if not reward is String:
        return
    sprite_2d.texture = Rewards.get_texture(reward)

    
