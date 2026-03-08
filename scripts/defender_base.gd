extends Plant
class_name Defender

# @onready var sprite = $Sprite
@onready var animation_player = $Sprite/AnimationPlayer
@onready var raycasts = $Raycasts
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

@export var tween_shot = false
@export var fire_delay := 2.0
@export var bullet_scene: PackedScene

var targets := []

func _ready():
    super._ready()
    await get_tree().create_timer(0.5).timeout
    #shoot_loop()

#---------------------------------------------------- compoent
#func get_targets() -> Array:
    #var targets := []
    #for ray in raycasts.get_children():
        #ray.force_raycast_update()
        #if ray.is_colliding():
            #var hit = ray.get_collider()
            #if hit.is_in_group("zombie_hurtboxes"):
                #targets.append(hit)
    #return targets
#
#
#
#func should_shoot():
    #var targets := get_targets()
    #if targets.is_empty():
        #return false
    #else:
        #return true
#---------------------------------------------------------



#func shoot_loop():
    #while true:
        #
        #while not should_shoot(): # repeating here while no targets means tower will shoot as soon as a zombie appears, instead of waiting for its fire_delay to cooldown. idk how to write this clearly
            #await get_tree().create_timer(0.01).timeout
        #
        #shoot_sound.play()
        ## messy animation stuff
        #if tween_shot:
            #var tween = create_tween()
            #tween.tween_property($Sprite, "scale", Vector2(1.1, 0.85), 0.1)
            #shoot(bullet_scene, $Marker2D)
            #tween.tween_property($Sprite, "scale", Vector2(1, 1), 0.1).set_delay(0.1)
        #else:
            #sprite.play("shoot")
            #animation_player.play("shoot") # this will call shoot() by itself thanks to AnimationPlayer stuffs
            #
        #await get_tree().create_timer(fire_delay).timeout
#
#
#
#func animationplayer_shoot():
    #shoot(bullet_scene, $Marker2D)


# ------------------------------------------------------------------------------
#func _on_sprite_animation_finished() -> void:
    #if sprite.animation == "shoot":
        #sprite.play("idle") 
    #if sprite.animation == "idle":
        #pass
        
