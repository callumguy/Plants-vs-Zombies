extends RigidBody2D

@onready var detachable: Detachable = $DetachableComponent
@onready var despawn: Despawn = $DespawnComponent


#func despawn():
#    despawn_component.despawn()    

func pop_off(global_transform_to_copy = null):
    print(global_transform_to_copy)
    
    visible = true
    detachable.pop_off()
    
    if global_transform_to_copy:
        global_transform = global_transform_to_copy
        global_scale = global_scale * Vector2(0.845, 0.845)

    
    
func set_lane(lane: int): # 0 - 4
    lane = lane
    collision_mask = 1 << (lane + 9 - 1)
