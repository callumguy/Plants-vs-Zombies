extends State
class_name PlantWaitingState
var plant: Node2D



func enter() -> void:
    plant = actor
    if plant.has_method("enter_waiting"):
        plant.enter_waiting()
    
    #while plant.sprite == null:
    #    await get_tree().process_frame
    # plant.sprite.play("idle")
    # plant.reanim.play(plant.animation_waiting_name, true)
    
func exit() -> void:
    pass
    
func update(delta: float) -> void:
    if not plant.raycast: # no raycasts means its a plant like sunflower that doesn't care about detecting things
        state_machine.change_state("action")
        return
    
    var raycast_hits = plant.raycast.get_targets()
    if raycast_hits.any(func(x): return x != null): # if at least one of the raycasts found something
        state_machine.change_state("action")
    
func physics_update(delta: float) -> void:
    pass
    
func handle_input(event: InputEvent) -> void:
    pass
    
