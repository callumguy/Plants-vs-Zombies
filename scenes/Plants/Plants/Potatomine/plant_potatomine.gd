extends Plant

@onready var projectile: PackedScene = preload("res://scenes/Projectiles/projectile_potatomine.tscn")

const ARM_TIME: float = 15

enum Status {PREPARING, ARMING, ARMED}
var status: int = Status.PREPARING
var delta_count: float = 0

func perform_action() -> void:
    if not status == Status.ARMED:
        return
    
    var raycast_hits = raycast.get_targets()
    if raycast_hits.any(func(x): return x != null): # if at least one of the raycasts found something
        reanim.stop("anim_armed")
        reanim.play("anim_mashed", true)
        shoot.shoot(projectile, raycast, true)
        await get_tree().create_timer(2).timeout
        die()
    
func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_idle") # THIS DOESNT STOP AUTOMATICALLY BECAUSE ITS A 1-FRAME ANIMATION. FIX IN REANIM COMPONENT SCRIPT
        
func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_rise":
        print("ARMED")
        status = Status.ARMED
        reanim.play("anim_armed", true)
        
func _process(delta: float) -> void:
    delta_count += delta
    print(delta_count)
    if delta_count >= ARM_TIME and status == Status.PREPARING:
        status = Status.ARMING
        reanim.stop("anim_idle")
        reanim.play("anim_rise")
    print(status)
    
