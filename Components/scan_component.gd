class_name ScanComponent extends Node

enum Shape {RECTANGLE, CIRCLE}

func get_targets(origin: Vector2, size: Vector2, collision_mask: int):
    size = size * Vector2(GridManager.cell_width, GridManager.cell_height)
    
    var query_shape = RectangleShape2D.new()
    query_shape.size = size
        
    var query = PhysicsShapeQueryParameters2D.new()
    query.shape = query_shape
    query.transform = Transform2D(0, origin)
    query.collision_mask = collision_mask
    
    query.collide_with_areas = true
    query.collide_with_bodies = false
    
    var colliders = get_tree().get_root().get_world_2d().direct_space_state.intersect_shape(query)
    return colliders.map(func(r): return r.collider)
