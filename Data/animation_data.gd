extends Node
class_name AnimationData


# shouldn't need this! -------------------
static var atlas_regions := {
    "spikeweed" = {
    "IMAGE_REANIM_CALTROP_BLINK1": Rect2i(138, 66, 46, 10),
    "IMAGE_REANIM_CALTROP_BLINK2": Rect2i(138, 55, 46, 10),
    },
    "cactus" = {
        "IMAGE_REANIM_CACTUS_BODY_OVERLAY": Rect2i(190, 11, 48, 13),
        "IMAGE_REANIM_CACTUS_BODY_OVERLAY2": Rect2i(239, 11, 48, 13)
    },
    "wallnut" = {
        "anim_face" = Rect2(1, 1, 100, 100),
        "anim_face2" = Rect2(103, 1, 100, 100),
        "anim_face3" = Rect2(205, 1, 100, 100)
    }
}
# ------------------------------------

static func find_file(folder: String, target_name: String) -> String:
    var dir = DirAccess.open(folder)
    if dir == null:
        return ""
    
    dir.list_dir_begin()
    var file_name = dir.get_next()
    
    while file_name != "":
        #print(file_name.to_lower(), " ", target_name.to_lower())
        if not dir.current_is_dir() and file_name.to_lower() == target_name.to_lower():
            dir.list_dir_end()
            return folder + "/" + file_name
        file_name = dir.get_next()
    
    dir.list_dir_end()
    return ""

const REANIM_FOLDER_PATH = "res://reanim/"
static func get_reanim_image(image_name: String) -> Variant:
    image_name = image_name.trim_prefix("IMAGE_REANIM_")
    var image_path = find_file(REANIM_FOLDER_PATH, image_name + ".png")
    if image_path != "":
        return load(image_path)
    else:
        print('reanim image not found: ', image_name)
        return null
    
    
    
    
    
    
