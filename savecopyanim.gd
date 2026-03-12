extends Node2D
class_name ReanimPlayercopy

var animations: Dictionary
var image_map = {
    "IMAGE_REANIM_CALTROP_BLINK1": Rect2i(138, 66, 46, 10),
    "IMAGE_REANIM_CALTROP_BLINK2": Rect2i(138, 55, 46, 10),
}

var current_animation: String
var current_animation_fps: int
var current_animation_start_frame: int
var current_animation_end_frame: int
var current_animation_current_frame: int

var count: float

func _ready() -> void:
    var content = FileAccess.get_file_as_string(PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt")
    animations = ReanimParser2.parse(content)
    play("anim_attack")

func play(anim_name: String):
    var anim = animations.get(anim_name)
    if not anim:
        return
    
    current_animation = anim_name
    current_animation_fps = 12
    current_animation_start_frame = animations[anim_name]['info']['start_frame'] 
    current_animation_end_frame = animations[anim_name]['info']['end_frame']
    current_animation_current_frame = animations[anim_name]['info']['start_frame'] - 1 # -1 since the first time a frame changes will be after this var increases in _process
    
func _process(delta: float) -> void:
    count += delta
    if count > (1.0 / current_animation_fps):
        count = 0
        current_animation_current_frame = wrapi(current_animation_current_frame + 1, current_animation_start_frame, current_animation_end_frame)
        print(current_animation_current_frame)
        
        for animation_name in animations.keys():
            var animation_frame = animations[animation_name]['frames'][current_animation_current_frame]
            print(animation_frame)
            apply_transforms(animation_frame, find_child(animation_name)) # find child takes lots of cpu juice? so cache it porbably
            
            
            
func apply_transforms(animation_frame: Dictionary, sprite: Sprite2D) -> void:
    var tags = ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    for tag in tags:
        if tag not in animation_frame:
            continue
        
        match tag:
            'x': sprite.position.x = animation_frame[tag]
            'y': sprite.position.y = animation_frame[tag]
            'sx': sprite.scale.x = animation_frame[tag]
            'sy': sprite.scale.y = animation_frame[tag]
            'kx': sprite.rotation = deg_to_rad(animation_frame[tag])
            'ky': sprite.rotation = deg_to_rad(animation_frame[tag])
            'i':
                sprite.texture.region = image_map[animation_frame[tag]]
