extends Node

var levels := {
    "default": {
        "reward": null,
        "seed_slots": 5,
    },
    "1": {
        "reward": "plant/cactus"
    },
    "2": {
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
