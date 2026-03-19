extends Node

enum Worlds {DAY, NIGHT}
const BASIC_ZOMBIES := ['basic', 'conehead', 'buckethead']

var levels := {
    "default": {
        "world": Worlds.DAY,
        "zombies": BASIC_ZOMBIES,
        "seed_slots": 5,
        "starting_sun": 50,
        "reward": null,
    },
    "1": {
        "zombies": ['basic'],
        "reward": "plant/puffshroom"
    },
    "2": {
        "zombies": ['basic', 'conehead'],
        "reward": "plant/cactus"
    },
    "3": {
        "zombies": ['basic', 'conehead'],
        "reward": "plant/sunshroom"
    },
    "4": {
        "world": Worlds.NIGHT,
        "starting_sun": 150,
        "reward": "plant/starfruit"
    },
    "5": {
        "reward": "plant/cactus"
    },
    "6": {
        "reward": "plant/spikeweed"
    },
    "7": { 
    },
    "8": {
        "world": Worlds.NIGHT,
        "starting_sun": 100
    }
}

func get_level_info(level_number: int, key: String) -> Variant:
    if key in levels[str(level_number)]: 
        return levels[str(level_number)][key]
    else:
        return levels['default'][key]
