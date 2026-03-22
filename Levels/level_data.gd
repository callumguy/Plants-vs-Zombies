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
        "reward": "plant/aspearagus"
    },
    "2": {
        "zombies": ['basic', 'conehead'],
        "reward": "plant/potatomine"
    },
    "3": {
        "zombies": ['basic', 'conehead'],
        "reward": "plant/spikeweed"
    },
    "4": {
        "reward": "plant/puffshroom"
    },
    "5": {
        "world": Worlds.NIGHT,
        "zombies": ['basic', 'conehead'],
        "starting_sun": 150,
        "reward": "plant/cherrybomb"
    },
    "6": {
        "reward": "plant/starfruit"
    },
    "7": {
        "reward": "plant/sunshroom"
    },
    "8": {
        "world": Worlds.NIGHT,
        "starting_sun": 150,
        "reward": "plant/cactus"
    }
}

func get_level_info(level_number: int, key: String) -> Variant:
    if key in levels[str(level_number)]: 
        return levels[str(level_number)][key]
    else:
        return levels['default'][key]
