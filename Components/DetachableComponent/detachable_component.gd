extends Node2D
class_name Detachable

@export var body: RigidBody2D

func pop_off():
    body.reparent(get_tree().current_scene)
    
    await get_tree().physics_frame
    
    body.freeze = false
    body.apply_impulse(Vector2(randf_range(-80, 80), -120))
    body.angular_velocity = randf_range(-8, 8)
    
    
