extends Plant

@export var sun_amount: int = 50

func perform_action() -> void:
    generate.generate(sun_amount)

func enter_cooldown() -> void:
    reanim.play("anim_idle", true)
