extends Area2D

@export var damage: int = 10
@export var pierce: int = 0

@export var speed: int = 400
@export var direction: Vector2 = Vector2.RIGHT
@export var max_travel_distance: int = 10000 # infinite basically // make this in terms of tiles

var start_position: Vector2

func _physics_process(delta: float) -> void:
    
    var space = get_world_2d().direct_space_state
    var query = PhysicsRayQueryParameters2D.create(
        global_position,
        global_position + direction * speed * delta # 'delta' is inconsistant. change this to be last pos to current pos instead
    )
    query.collision_mask = 1 << 1 # mask 2
    query.collide_with_areas = true
    query.collide_with_bodies = false
    query.exclude = [self]
    
    var collider = space.intersect_ray(query)
    if collider:
        _on_hit(collider)
    
    global_position += direction * speed * delta
    if global_position.distance_to(start_position) > max_travel_distance:
        queue_free()
        
func _on_hit(collider: Dictionary):
    var collider_position = collider.get("position") # exactly where the ray hit
    var collider_node = collider.get("collider")
    var collider_parent = collider_node.get_parent()
    if collider_parent.has_method("take_damage"):
        collider_parent.take_damage(damage)
    
    if pierce <= 0:
        queue_free()
    pierce -= 1
    

#@export var hit_effect_scene: PackedScene
#

#
#func _physics_process(delta):
    #position += direction * speed * delta
    #if global_position.distance_to(start_position) >= max_distance:
        #queue_free()
    #if position.x > GameManager.window_width + 50:
        #queue_free()
#
#func _on_area_entered(area):
    #if area.is_in_group("zombie_hurtboxes"):
        #
        #pierce -= 1
        #if pierce < 0: # 0 pierce is like a normal pea. so destroy projectiles when they are at -1 pierce
            #if hit_effect_scene != null:
                #var effect = hit_effect_scene.instantiate()
                #effect.global_position = global_position
                #get_tree().current_scene.add_child(effect)
            #
            #collision_layer = 0
            #collision_mask = 0
            #
            #queue_free()
            #
            
#func _ready():
#    self.area_entered.connect(_on_area_entered)

#func get_damage(): # function for the zombies that get hit to use
#    return damage
