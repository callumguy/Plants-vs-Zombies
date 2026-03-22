extends CharacterBody2D
class_name Zombie

signal zombie_at_house(zombie_position: Vector2)
signal zombie_died(zombie_position: Vector2)
signal damaged(zombie, amount: int)

@onready var state_machine: StateMachine = $StateMachine

@onready var health: Health = $HealthComponent
@onready var hurtbox: Hurtbox = $HurtboxComponent
@onready var movement: Movement = $MovementComponent
@onready var flash: Flash = $FlashComponent

@onready var helmet: RigidBody2D = $Visuals/Skeleton3/Skeleton2D/Torso/Head/Helmet.get_node_or_null("Helmet")
@onready var zombie_arm: RigidBody2D = $Visuals2/ZombieArm
@onready var zombie_head: RigidBody2D = $Visuals2/ZombieHead

@onready var skeleton_animationplayer = $Visuals/Skeleton3/AnimationPlayer
@onready var bite_raycast = $BiteRaycast

@onready var splat_sound = $SplatSound

@export var damage := 10 # damage component!

var is_eating = false
var eat_targets = []
var has_arm = true
var lane: int
var wave: int

func _ready():
    connections()
    if helmet:
        helmet.set_lane(lane)
    zombie_head.set_lane(lane)
    zombie_arm.set_lane(lane)
    
    skeleton_animationplayer.animation_finished.connect(_on_animation_finished)
    
    state_machine.change_state("walking")

func connections() -> void:
    hurtbox.damaged.connect(take_damage)
    health.health_changed.connect(health_changed)
    health.died.connect(die)

func die():
    state_machine.change_state("dying")    

func health_changed(health: int, max_health: int): # when health component changes
    splat_sound.play()
    flash.flash()
    
    if health <= max_health / 2 and has_arm:
        has_arm = false
        var skeleton_shoulder_sprite = $Visuals/Skeleton3/Skeleton2D/Torso/LeftShoulder/AnimatedSprite2D
        skeleton_shoulder_sprite.frame = 1
        var skeleton_forearm = $Visuals/Skeleton3/Skeleton2D/Torso/LeftShoulder/LeftForearm
        skeleton_forearm.visible = false
        
        zombie_arm.find_child("Visuals").scale = $Visuals.scale
        zombie_arm.pop_off()
        zombie_arm.despawn.despawn(1, 0.5)

    
func take_damage(amount): # changes health component
    var start_health =  health.health
    
    if helmet:
        start_health += helmet.health.health
        var helmet_health = helmet.health.health
        var overkill_damage = max(amount - helmet_health, 0)
        helmet.health.take_damage(amount)
        health.take_damage(overkill_damage)
        if helmet_health - amount <= 0:
            helmet = null
    else:
        health.take_damage(amount)
        
    # var damage_taken = start_health - (health.health + helmet.health.health)
    var damage_taken = clampi(amount, 0, start_health)
    
    emit_signal("damaged", self, damage_taken)
    
func _on_animation_finished(anim_name) -> void:
    if anim_name == "death":
        queue_free()

func get_targets():
    var targets = []
    bite_raycast.force_raycast_update()
    if bite_raycast.is_colliding():
        var hit = bite_raycast.get_collider()
        if hit.is_in_group("plant_hurtboxes"):
            targets.append(hit)
            
    return targets
    
func should_eat():
    eat_targets = get_targets()
    if eat_targets.is_empty():
        return false
    return true
    

    
    
            
    
        
    
    
