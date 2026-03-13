extends Node

const PLANTS_FOLDER := "res://scenes/Plants/Plants/"
const SEED_PACKET_FOLDER := "res://scenes/Plants/SeedPackets/"

const ICON_ATLAS_TEXTURE = preload(SEED_PACKET_FOLDER + "Icons.png")
const ICON_ATLAS_WIDTH := 8

const RECHARGE_FAST := 7.5
const RECHARGE_MEDIUM := 15
const RECHARGE_LONG := 30
const RECHARGE_VERY_LONG := 60

# Returns a rectangle that can be used to get a plant's icon texture from the atlas.
func id_to_rect(id: int) -> Rect2:
    var row = floor(id / ICON_ATLAS_WIDTH)
    var col = id % ICON_ATLAS_WIDTH
    
    var rect_corner = Vector2(2, 2) + Vector2(111 * col, 72 * row)
    var rect_size = Vector2(109, 70)
    return Rect2(rect_corner.x, rect_corner.y, rect_size.x, rect_size.y)

func id_to_path(id: String) -> String:
    return PLANTS_FOLDER + id.capitalize() + "/plant_" + id + ".tscn" 
    
var plants := {
    "peashooter": {
        "scene" = load(id_to_path("peashooter")),
        "icon_region" = id_to_rect(0), 
        "cost" = 100,
        "recharge" = RECHARGE_FAST,
    },
    "sunflower": {
        "scene" = load(id_to_path("sunflower")),
        "icon_region" = id_to_rect(1),
        "cost" = 50,
        "recharge" = RECHARGE_FAST,
    },
    "wallnut": {
        "scene" = load(id_to_path("wallnut")),
        "icon_region" = id_to_rect(3),
        "cost" = 50,
        "recharge" = 20.0
    },
    "cactus": {
        "scene" = load(id_to_path("cactus")),
        "icon_region" = id_to_rect(26),
        "cost" = 150,
        "recharge" = RECHARGE_FAST,
        "description" = "Shoots piercing spikes through zombies."
    },
    "starfruit": {
        "scene" = load(id_to_path("starfruit")),
        "icon_region" = id_to_rect(29),
        "cost" = 125,
        "recharge" = RECHARGE_FAST,
        "description" = "Shoots stars in 5 directions."
    },
    "spikeweed": {
        "scene" = load(id_to_path("spikeweed")),
        "icon_region" = id_to_rect(21),
        "cost" = 125,
        "recharge" = RECHARGE_FAST,
        "description" = "Damages zombies that walk over it."
    },
    "aspearagus": {
        "scene" = load(id_to_path("aspearagus")),
        "icon_region" = id_to_rect(9),
        "cost" = 100,
        "recharge" = RECHARGE_MEDIUM,
        "description" = "SHOOTS SPEARS"
    }
}

func _ready() -> void:
    print("loaded")
