extends State
class_name ZombieDyingState
var zombie: CharacterBody2D

func enter() -> void:
    zombie = actor
    
    var skeleton_head = zombie.get_node("Visuals/Skeleton3/Skeleton2D/Torso/Head")
    skeleton_head.visible = false
    
    var zombie_head = zombie.get_node("Visuals2/ZombieHead")
    zombie_head.find_child("Visuals").scale = zombie.find_child("Visuals").scale
    zombie_head.pop_off()
    zombie_head.despawn.despawn(1, 0.5)
    
    zombie.movement.speed = 0
    
    var skeleton_animationplayer = zombie.get_node("Visuals/Skeleton3/AnimationPlayer")
    skeleton_animationplayer.play("death")
    
    var hurtbox = zombie.find_child("Hurtbox")
    hurtbox.collision_layer = 0
    hurtbox.collision_mask = 0
    
    zombie.zombie_died.emit(zombie.position)
    
