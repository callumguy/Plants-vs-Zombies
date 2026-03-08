extends Area2D

@export var speed := 400
@export var damage := 1
@export var max_distance := 10000 # infinite basically
@export var pierce := 0

@export var hit_effect_scene: PackedScene

var start_position = Vector2.ZERO
var direction := Vector2.RIGHT

func _physics_process(delta):
    position += direction * speed * delta
    if global_position.distance_to(start_position) >= max_distance:
        queue_free()
    if position.x > GameManager.window_width + 50:
        queue_free()

func _on_area_entered(area):
    if area.is_in_group("zombie_hurtboxes"):
        
        pierce -= 1
        if pierce < 0: # 0 pierce is like a normal pea. so destroy projectiles when they are at -1 pierce
            var effect = hit_effect_scene.instantiate()
            effect.global_position = global_position
            get_tree().current_scene.add_child(effect)
            
            collision_layer = 0
            collision_mask = 0
            
            queue_free()
            
func _ready():
    self.area_entered.connect(_on_area_entered)


func get_damage(): # function for the zombies that get hit to use
    return damage
