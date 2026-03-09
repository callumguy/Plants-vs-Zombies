extends RigidBody2D

@onready var health: Health = $HealthComponent
@onready var damage_visuals: DamageVisuals = $DamageVisualsComponent
@onready var detachable: Detachable = $DetachableComponent
@onready var despawn: Despawn = $DespawnComponent
@onready var flash: Flash = $FlashComponent
@onready var hit_sound: AudioStreamPlayer = $HitSound

var lane: int

func _ready() -> void:
    connections()
    
func connections() -> void:
    health.health_changed.connect(_on_health_changed)
    health.died.connect(died)
    
func died() -> void:
    detachable.pop_off()
    despawn.despawn(1, 0.5)
    
func set_lane(lane: int): # 0 - 4
    lane = lane
    collision_mask = 1 << (lane + 9 - 1)
    
func _on_health_changed(current_health, max_health) -> void:
    print("play")
    hit_sound.play()
    damage_visuals._on_health_changed(current_health, max_health)
    flash.flash()
