extends Plant

#@onready var animation: Animate = get_node_or_null("AnimationComponent")
#var blink_delay := 10.0
#var count := 0.0
#
#func _process(delta: float) -> void:
    #count += delta
    #if count >= blink_delay:
        #count -= blink_delay
        #animation.blink()
        
func enter_waiting() -> void:
    reanim.play("anim_idle", true)
