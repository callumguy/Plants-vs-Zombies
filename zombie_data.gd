extends Node

const ZOMBIES_FOLDER := "res://scenes/Zombies/Zombies/"

const BASIC_HEALTH := 100

func id_to_path(id: String) -> String:
    return ZOMBIES_FOLDER + id.capitalize() + "/zombie_" + id + ".tscn" 

var helmets := {
    "cone": {
        "health" = 180
    },
    "bucket": {
        "health" = 600
    },
}

var zombies := {
    "basic": {
        "scene" = load(id_to_path("basic")),
        "cost" = 1,
        "health" = BASIC_HEALTH
    },
    "conehead": {
        "scene" = load(id_to_path("conehead")),
        "cost" = 2,
        "health" = BASIC_HEALTH + helmets['cone']['health']
    },
    "buckethead": {
        "scene" = load(id_to_path("buckethead")),
        "cost" = 4,
        "health" = BASIC_HEALTH + helmets['bucket']['health']
    },
}
