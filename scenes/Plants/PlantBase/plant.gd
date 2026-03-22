class_name Plant extends Node2D

signal tower_destroyed(tower)

@onready var sprite = $Sprite
@onready var sun_scene := preload(ScenePaths.SUN)

@onready var statemachine: StateMachine = $StateMachine
@export var cooldown: float = 1.4
var speed_multiplier: float = 1.0

@onready var health: Health = $HealthComponent
@onready var hurtbox: Hurtbox = $HurtboxComponent
@onready var damage_visuals: DamageVisuals = get_node_or_null("DamageVisualsComponent") # not all plants have
@onready var flash: Flash = $FlashComponent
@onready var raycast: Raycast = get_node_or_null("RaycastComponent")
@onready var animate: Animate = get_node_or_null("AnimationComponent") # not used anymore i think
@onready var reanim: ReanimComponent = get_node_or_null("ReanimComponent")

@onready var shoot: Shoot = get_node_or_null("ShootComponent")
@onready var generate: Generate = get_node_or_null("GenerateComponent")
@onready var splash: Splash = get_node_or_null("SplashComponent")
@onready var scan: ScanComponent = get_node_or_null("ScanComponent")

var lane: int
var column: int

func _ready():
    connections()

func connections() -> void:
    health.health_changed.connect(_on_health_changed)
    health.died.connect(die)
    reanim.animation_finished.connect(animation_finished)
    
func _on_health_changed(amount: int, max_health: int):
    flash.flash()
    if damage_visuals:
        damage_visuals._on_health_changed(health.health, health.max_health)

func die():
    tower_destroyed.emit(self)
    queue_free()

func animation_finished(animation_name: String) -> void:
    pass

# ----- STATES ----- #
