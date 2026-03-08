class_name Entity

signal died # listened to by whoever needs to hear, namely EnemyManager & PlacementManager

@onready var health_component: Health = $HealthComponent
@onready var hurtbox_component: Hurtbox = $HurtboxComponent
@onready var statemachine: StateMachine = $StateMachine

var grid_position: Vector2
var sprites: Array


func _ready() -> void:
    connections()
    
func connections() -> void:
    health_component.health_changed.connect(_health_changed)
    health_component.died.connect(_died)
    
func _health_changed(health: int, max_health: int) -> void:
    hurt_flash_effect()
    
func _died() -> void:
    if statemachine.states.has("dying"):
        statemachine.change_state("dying")
    else:
        queue_free()

# --- Flash effect when taking damage

#func _get_all_sprites() -> Array:
    #return find_children("*", "Sprite2D", true, false)
    #
#func hurt_flash_effect() -> void:
    #if sprites.is_empty():
        #sprites = _get_all_sprites()
    #
    #for sprite in sprites:
        #sprite.modulate = Color(2, 2, 2)
    #await get_tree().create_timer(0.08).timeout
    #for sprite in sprites:
        #sprite.modulate = Color(1, 1, 1)

# --
    
    
    
