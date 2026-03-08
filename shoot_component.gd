extends Node2D
class_name Shoot

@onready var projectile_folder: Node2D = get_tree().current_scene.find_child("ProjectileFolder")
#@export var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile_pea.tscn")
#@export var always_shoot_all: bool = false # shoots all cannons even if only one cannon sees a zombie when true

func _spawn_projectile(projectile_scene: PackedScene, location: Vector2, direction: Vector2) -> void:
    var projectile = projectile_scene.instantiate()
    projectile_folder.add_child(projectile) # should be a child somewhere else probably...
    projectile.global_position = location
    projectile.start_position = location # var in projectile script
    projectile.direction = direction
    
func shoot(projectile_scene: PackedScene, raycast_component: Node2D, shoot_all: bool = false) -> void: # shoot component should not be tied to raycast component like this but oh well
    var raycast_hits = raycast_component.get_targets()
    var len_raycast_hits = len(raycast_hits)
    
    var raycast_info = raycast_component.get_raycast_info()
    var raycast_positions = raycast_info[0]
    var raycast_directions = raycast_info[1]
    
    for i in range(len_raycast_hits):
        if shoot_all or raycast_hits[i] != null:
            _spawn_projectile(projectile_scene, raycast_positions[i], raycast_directions[i])       
 

func shoot_one(projectile_scene: PackedScene, raycast: RayCast2D) -> void:
    var raycast_start_position = raycast.global_position
    var raycast_end_position = raycast.to_global(raycast.target_position)
    var raycast_direction = (raycast_end_position - raycast_start_position).normalized()
    
    print(raycast_start_position, raycast_direction)
    _spawn_projectile(projectile_scene, raycast_start_position, raycast_direction)
