extends Node2D
class_name Raycast

@export var raycasts: Node2D

func get_targets() -> Array:
    var targets := []
    for raycast in raycasts.get_children():
        raycast.force_raycast_update()
        targets.append(raycast.get_collider()) # maybe do a safety check before this to make sure target is in an enemy group
    return targets

func get_raycast_info() -> Array:
    var positions = []
    var directions = []
    for raycast in raycasts.get_children():
        var start_position: Vector2 = raycast.global_position
        var end_position: Vector2 = raycast.to_global(raycast.target_position)
        var direction: Vector2 = (end_position - start_position).normalized()
        positions.append(start_position)
        directions.append(direction)
    
    return [positions, directions]
