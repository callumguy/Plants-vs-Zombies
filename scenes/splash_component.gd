class_name Splash extends Node

enum Shape {RECTANGLE, CIRCLE}

@export var shape: Shape = Shape.RECTANGLE
@export var size: Vector2 = Vector2(1, 1)
@export var collision_mask: int = 1 << 1

func get_targets(origin: Vector2):
    var query_shape
    
    if shape == Shape.RECTANGLE:
        query_shape = RectangleShape2D.new()
        query_shape.size = size * Vector2(GameManager.CELL_WIDTH, GameManager.CELL_HEIGHT)
        print(query_shape.size)
    else:
        query_shape = CircleShape2D.new()
        query_shape.size = size * Vector2(GameManager.CELL_WIDTH, GameManager.CELL_HEIGHT)
        
    var query = PhysicsShapeQueryParameters2D.new()
    query.shape = query_shape
    query.transform = Transform2D(0, origin)
    query.collision_mask = collision_mask
    query.collide_with_areas = true
    query.collide_with_bodies = false
    
    var colliders = get_tree().get_root().get_world_2d().direct_space_state.intersect_shape(query)
    return colliders.map(func(r): return r.collider)
