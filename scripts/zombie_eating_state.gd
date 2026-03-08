extends State
class_name ZombieEatingState
var zombie: CharacterBody2D

var damage_count := 0.0

func enter() -> void:
    zombie = state_machine.get_parent()
    
    zombie.movement.speed = 0
    zombie.skeleton_animationplayer.play("eat")

    damage_count = 0.0
    
func update(delta) -> void:
    var plants: Array = zombie.get_targets()
    
    if not plants.is_empty(): # nom nom
        var plant = plants[0].get_parent()
        
        damage_count += zombie.damage * delta
        var int_damage_count = int(damage_count)
        
        if damage_count >= 1: # deals damage in ints
            damage_count -= int_damage_count
            plant.health.take_damage(int_damage_count)
            # print(int_damage_count)

    else: # no plant in range, so start walking
        state_machine.change_state("walking")
        
