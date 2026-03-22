extends Plant

#@onready var sprite = $Sprite

@export var generate_delay := 10.0
@export var generate_amount := 25
var generate_timer: float

#func _ready():
#    super._ready()
#    generate_timer = generate_delay


#func _process(delta: float) -> void:
#    generate_timer -= delta
#    if generate_timer <= 0:
#        produce_sun(generate_amount)
#        generate_timer = generate_delay
    
