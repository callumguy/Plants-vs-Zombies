extends Node

const ICON_ATLAS_TEXTURE := preload("res://assets/pvzseedpackets.png")
const ICON_ATLAS_WIDTH := 8

# Returns a rectangle that can be used to get a plant's icon texture from the atlas.
func id_to_rect(id: int) -> Rect2:
    var row = floor(id / ICON_ATLAS_WIDTH)
    var col = id % ICON_ATLAS_WIDTH
    
    var rect_corner = Vector2(2, 2) + Vector2(111 * col, 72 * row)
    var rect_size = Vector2(109, 70)
    return Rect2(rect_corner.x, rect_corner.y, rect_size.x, rect_size.y)
    
    
var plants := {
    "peashooter": {
        "scene" = preload("res://plant_peashooter.tscn"),
        "icon_region" = id_to_rect(0), 
        "cost" = 100,
        "recharge" = 5.0,
    },
    "sunflower": {
        "scene" = preload("res://plant_sunflower.tscn"),
        "icon_region" = id_to_rect(1),
        "cost" = 50,
        "recharge" = 5.0,
    },
    "wallnut": {
        "scene" = preload("res://plant_wallnut.tscn"),
        "icon_region" = id_to_rect(3),
        "cost" = 50,
        "recharge" = 20.0
    },
    "cactus": {
        "scene" = preload("res://plant_cactus.tscn"),
        "icon_region" = id_to_rect(26),
        "cost" = 150,
        "recharge" = 5.0,
        "description" = "Shoots piercing spikes through zombies."
    },
    "starfruit": {
        "scene" = preload("res://plant_starfruit.tscn"),
        "icon_region" = id_to_rect(29),
        "cost" = 125,
        "recharge" = 5.0,
        "description" = "Shoots stars in 5 directions."
    },
    "spikeweed": {
    "scene" = preload("res://plant_spikeweed.tscn"),
    "icon_region" = id_to_rect(21),
    "cost" = 125,
    "recharge" = 5.0,
    "description" = "Damages zombies that walk over it."
    },
}

func _ready() -> void:
    print("loaded")
