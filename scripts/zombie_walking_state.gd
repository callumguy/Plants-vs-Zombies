extends State
class_name ZombieWalkingState
var zombie: CharacterBody2D

func enter() -> void:
    zombie = actor
    zombie.movement.speed = zombie.movement.base_speed
    zombie.skeleton_animationplayer.play("walk")

func update(delta) -> void:
    
    if zombie.position.x < GameManager.HOUSE_X:
        zombie.zombie_at_house.emit(zombie.position)
    
    if zombie.should_eat():
        state_machine.change_state("eating")
