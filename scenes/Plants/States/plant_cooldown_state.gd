extends State
class_name PlantCooldownState
var plant: Node2D

var cooldown_length := 2.0
var count: float

func enter() -> void:
    plant = actor
    #while plant.sprite == null:
    #    await get_tree().process_frame
    # plant.sprite.play("idle")
    
    if plant.has_method("enter_cooldown"):
        plant.enter_cooldown()
    
    cooldown_length = plant.cooldown
    
    count = 0
    
func exit() -> void:
    pass
    
func update(delta: float) -> void:
    count += delta
    if count >= cooldown_length:
        state_machine.change_state("waiting")
    
func physics_update(delta: float) -> void:
    pass
    
func handle_input(event: InputEvent) -> void:
    pass
