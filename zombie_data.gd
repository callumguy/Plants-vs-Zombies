extends Node

const BASIC_HEALTH := 100

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
        "scene" = preload("res://scenes/zombies/zombie_basic.tscn"),
        "cost" = 1,
        "health" = BASIC_HEALTH
    },
    "conehead": {
        "scene" = preload("res://scenes/zombies/zombie_cone.tscn"),
        "cost" = 2,
        "health" = BASIC_HEALTH + helmets['cone']['health']
    },
    "buckethead": {
        "scene" = preload("res://scenes/zombies/zombie_bucket.tscn"),
        "cost" = 4,
        "health" = BASIC_HEALTH + helmets['bucket']['health']
    },
}
