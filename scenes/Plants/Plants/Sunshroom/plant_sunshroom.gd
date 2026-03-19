extends Plant

const SMALL_SUN_AMOUNT: int = 15
const BIG_SUN_AMOUNT: int = 25

const ACTIONS_TO_GROW: int = 5
var actions_performed: int = 0

enum Size {SMALL, BIG}
var current_size: int = Size.SMALL


func perform_action() -> void:
    actions_performed += 1
    if actions_performed == ACTIONS_TO_GROW:
        current_size = Size.BIG
        reanim.stop("anim_idle")
        reanim.play("anim_grow")
    
    var amount: int
    match current_size:
        Size.SMALL: amount = SMALL_SUN_AMOUNT
        Size.BIG: amount = BIG_SUN_AMOUNT
    generate.generate(amount)

func enter_cooldown() -> void:
    if len(reanim.current_animations) == 0:
        match current_size:
            Size.SMALL: reanim.play("anim_idle", true)
            Size.BIG: reanim.play("anim_big_idle", true)

func animation_finished(animation_name: String) -> void:
    if animation_name == "anim_grow":
        reanim.play("anim_big_idle", true)
