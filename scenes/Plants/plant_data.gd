class_name PlantData extends Node
        
const PLANTS_FOLDER := "res://scenes/Plants/Plants/"
const SEED_PACKET_FOLDER := "res://scenes/Plants/SeedPackets/"

const ICON_ATLAS_TEXTURE = preload(SEED_PACKET_FOLDER + "Icons.png")
const ICON_ATLAS_WIDTH := 8

const RECHARGE_FAST := 7.5 # sunflower, peashooter, repeater
const RECHARGE_MEDIUM := 15
const RECHARGE_SLOW := 30 # wallnut, potato mine, hypno shroom
const RECHARGE_VERY_SLOW := 50 # cherry bomb, jalapeno, doom shroom

# Returns a rectangle that can be used to get a plant's icon texture from the atlas.
static func _id_to_rect(id: int) -> Rect2:
    var row = floor(id / ICON_ATLAS_WIDTH)
    var col = id % ICON_ATLAS_WIDTH
    
    var rect_corner = Vector2(2, 2) + Vector2(111 * col, 72 * row)
    var rect_size = Vector2(109, 70)
    return Rect2(rect_corner.x, rect_corner.y, rect_size.x, rect_size.y)

static func _id_to_path(id: String) -> String:
    return PLANTS_FOLDER + id.capitalize() + "/plant_" + id + ".tscn" 
    
static var plants := {
    "peashooter": {
        "scene" = load(_id_to_path("peashooter")),
        "icon_region" = _id_to_rect(0), 
        "cost" = 100,
        "recharge" = RECHARGE_FAST,
        "description" = ""
    },
    "sunflower": {
        "scene" = load(_id_to_path("sunflower")),
        "icon_region" = _id_to_rect(1),
        "cost" = 50,
        "recharge" = RECHARGE_FAST,
        "description" = ""
    },
    "wallnut": {
        "scene" = load(_id_to_path("wallnut")),
        "icon_region" = _id_to_rect(3),
        "cost" = 50,
        "recharge" = RECHARGE_SLOW,
        "description" = ""
    },
    "cactus": {
        "scene" = load(_id_to_path("cactus")),
        "icon_region" = _id_to_rect(26),
        "cost" = 150,
        "recharge" = RECHARGE_FAST,
        "description" = "Shoots piercing spikes through zombies."
    },
    "starfruit": {
        "scene" = load(_id_to_path("starfruit")),
        "icon_region" = _id_to_rect(29),
        "cost" = 125,
        "recharge" = RECHARGE_FAST,
        "description" = "Shoots stars in 5 directions."
    },
    "spikeweed": {
        "scene" = load(_id_to_path("spikeweed")),
        "icon_region" = _id_to_rect(21),
        "cost" = 125,
        "recharge" = RECHARGE_FAST,
        "description" = "Damages zombies that walk over it."
    },
    "aspearagus": {
        "scene" = load(_id_to_path("aspearagus")),
        "icon_region" = _id_to_rect(9),
        "cost" = 100,
        "recharge" = RECHARGE_FAST,
        "description" = "Shoots ze spears."
    },
    "cherrybomb": {
        "scene" = load(_id_to_path("cherrybomb")),
        "icon_region" = _id_to_rect(2),
        "cost" = 150,
        "recharge" = RECHARGE_SLOW,
        "description" = "Explodes in a 3x3 area."
    },
    "puffshroom": {
        "scene" = load(_id_to_path("puffshroom")),
        "icon_region" = _id_to_rect(8),
        "cost" = 25,
        "recharge" = RECHARGE_SLOW,
        "description" = "Shoots spores at nearby zombies."
    },
    "sunshroom": {
        "scene" = load(_id_to_path("sunshroom")),
        "icon_region" = _id_to_rect(9),
        "cost" = 25,
        "recharge" = RECHARGE_FAST,
        "description" = "Produces little sun at first, then more sun later."
    },
    "potatomine": {
        "scene" = load(_id_to_path("potatomine")),
        "icon_region" = _id_to_rect(4),
        "cost" = 25,
        "recharge" = RECHARGE_SLOW,
        "description" = "Explodes on contact with zombies. Takes time to arm itself."
    },
}
