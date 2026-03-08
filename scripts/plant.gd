extends Node2D
class_name Plant

signal tower_destroyed(tower)

@onready var sprite = $Sprite
@onready var sun_scene := preload("res://scenes/sun.tscn")

@onready var statemachine: StateMachine = $StateMachine
@export var cooldown: float = 1.4

@onready var health: Health = $HealthComponent
@onready var hurtbox: Hurtbox = $HurtboxComponent
@onready var damage_visuals: DamageVisuals = get_node_or_null("DamageVisualsComponent") # not all plants have
@onready var flash: Flash = $FlashComponent
@onready var raycast: Raycast = get_node_or_null("RaycastComponent")
@onready var animate: Animate = get_node_or_null("AnimationComponent")

@onready var shoot: Shoot = get_node_or_null("ShootComponent")
@onready var generate: Generate = get_node_or_null("GenerateComponent")

# @onready var sun_folder: Node2D = get_tree().current_scene.get_node("%SunFolder")

@export var sun_cost := 100 ## seed packet scene?
@export var recharge := 7.5 ## ------------------

var lane: int
var column: int

func _ready():
    connections()
    #statemachine.change_state("waiting")

func connections() -> void:
    health.health_changed.connect(_on_health_changed)
    health.died.connect(die)
    
func _on_health_changed(amount: int, max_health: int):
    flash.flash()
    if damage_visuals:
        damage_visuals._on_health_changed(health.health, health.max_health)

func die():
    tower_destroyed.emit(self)
    queue_free()






#func _on_sprite_animation_finished() -> void: # state machine can do this <--------------------------
#    if sprite.animation == "shoot":
#        sprite.play("idle") 
#    if sprite.animation == "idle":
#        pass
        
#func produce_sun(amount: int): 
    #var sun = sun_scene.instantiate()
    #sun.global_position = global_position
    #sun.lane = lane
    #sun.column = column
    #sun_folder.add_child(sun)
    #sun.spawn_movement()

#func shoot(projectile_scene: PackedScene, spawn_marker: Marker2D):
    #var projectile = projectile_scene.instantiate()
    #projectile.position = spawn_marker.position
    #add_child(projectile)
