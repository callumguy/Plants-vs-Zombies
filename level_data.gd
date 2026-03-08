extends Node

const BASIC_ZOMBIES := ['basic', 'conehead', 'buckethead']

var levels := {
    "default": {
        "zombies": BASIC_ZOMBIES,
        "seed_slots": 5,
        "reward": null,
    },
    "1": {
        "zombies": ['basic'],
        "reward": "plant/cactus"
    },
    "2": {
        "zombies": ['basic', 'conehead'],
        "reward": "plant/starfruit"
    },
    "3": {
        "reward": "plant/spikeweed"
    },
    "4": {
        # nada
    },
    "5": {
        "seed_slots": 3
    },
    "6": {
        #nada
    }
}

func get_level_info(level_number: int, key: String) -> Variant:
    if key in levels[str(level_number)]: 
        return levels[str(level_number)][key]
    else:
        return levels['default'][key]
