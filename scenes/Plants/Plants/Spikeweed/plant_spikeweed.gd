extends Plant

# @export var projectile: PackedScene = preload(ScenePaths.PROJECTILE_PEA)
# @export var always_shoot: bool = false

func perform_action() -> void:

    # shoot.shoot_one(projectile, $Raycasts/Up)
    var targets = scan.get_targets(global_position, Vector2(0.5, 0.5), 2)
    for target in targets:
        target.get_parent().take_damage(10)
    
    reanim.stop("anim_idle")
    reanim.play("anim_attack")

func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        reanim.play("anim_idle", true)

func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_attack":
        reanim.play("anim_idle", true)
