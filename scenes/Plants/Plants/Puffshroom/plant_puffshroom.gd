extends Plant

var projectile = preload(ScenePaths.PROJECTILES + "projectile_spore.tscn")

const ATTACK_RANGE: float = 3.5
const ATTACK_SPEED: float = 1.4
var attack_cooldown: float = ATTACK_SPEED

#func perform_action() -> void:
    #reanim.stop("anim_idle")
    #reanim.play("anim_shooting", false, 3.0)
    #shoot.new_shoot(projectile, global_position, Vector2.RIGHT)
    #
#func enter_cooldown() -> void:
    #if len(reanim.current_animations) == 0:
        #reanim.play("anim_idle", true)
    #
#func animation_finished(animation_name: String) -> void:
    #if animation_name == "anim_shooting":
        #reanim.play("anim_idle", true)


func _process(delta: float) -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_idle", true)
    
    attack_cooldown -= delta * speed_multiplier
    if attack_cooldown <= 0.0:
        if scan.get_targets(global_position + GridManager.grid_range_to_range(Vector2(ATTACK_RANGE, 0)) / Vector2(2, 2), Vector2(ATTACK_RANGE, 0), 2):
            attack_cooldown = ATTACK_SPEED
            reanim.play("anim_shooting", false, 3.0)
            shoot.new_shoot(projectile, global_position, Vector2.RIGHT)

func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_shooting":
        reanim.play("anim_idle", true)
        
    
