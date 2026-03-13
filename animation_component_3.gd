extends Node2D
class_name ReanimComponent

signal animation_finished(animation_name: String)

@export_file("*.txt") var reanim_path: String = PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt"

var actor
var animations: Dictionary
var current_animations: Array = []

var ooga_booga: String

func _ready() -> void:
    actor = get_parent()
    var content = FileAccess.get_file_as_string(reanim_path)
    animations = ReanimParser2.parse(content)
    apply_default_transforms()

func play(anim_name: String, loop: bool = false, custom_start_frame: int = -1): # make it so if played with loop=true it overrides the non looper and vise-versa
    var anim = animations.get(anim_name)
    if not anim:
        return
    for current_animation in current_animations:
        if anim_name == current_animation['name']:
            return
        
    var anim_info: Dictionary = {}
    anim_info['fps'] = 12
    anim_info['delta_count'] = 0
    
    anim_info['name'] = anim_name
    if custom_start_frame == -1:
        anim_info['start_frame'] = animations[anim_name]['info']['start_frame'] # no start frame given so set to the default
    else:
        anim_info['start_frame'] = custom_start_frame # start midway through the animation
    anim_info['end_frame'] = animations[anim_name]['info']['end_frame']
    anim_info['current_frame'] = animations[anim_name]['info']['start_frame'] - 1 # -1 since the first time a frame changes will be after this var increases in _process
    anim_info['looping'] = loop
    current_animations.append(anim_info)
    # print(anim_info)

func stop(anim_name: String) -> int:
    for current_animation in current_animations:
        if anim_name == current_animation['name']:
            var frame_ended_on = current_animation['current_frame']
            current_animations.erase(current_animation)
            emit_signal("animation_finished", anim_name)
            
            return frame_ended_on
    return -1 # uuuuuuuuuuuuuuuuuh
    
func _process(delta: float) -> void:
    print(current_animations)
    visible = true
    # print("---")
    for anim_info in current_animations:
        #print(anim_info['name'])
        anim_info['delta_count'] += delta
        if anim_info['delta_count'] < (1.0 / anim_info['fps']):
            continue # it's not time for this animations next frame yet
        anim_info['delta_count'] = 0
        
        var was = anim_info['current_frame'] # mmm
        anim_info['current_frame'] = wrapi(anim_info['current_frame'] + 1, anim_info['start_frame'], anim_info['end_frame'] + 1)
        var _is = anim_info['current_frame'] # mmm
        
        # print(anim_info['current_frame'])
        
        if _is < was and not anim_info['looping']: # mmm
            stop(anim_info['name']) # mmm
            continue # mmm
        
        for animation_name in animations.keys():
            var animation_frame = animations[animation_name]['frames'][anim_info['current_frame']]
            ooga_booga = anim_info['name']
            apply_transforms(animation_frame, find_child(animation_name)) # find child takes lots of cpu juice? so cache it porbably
            
func apply_transforms(animation_frame: Dictionary, sprite: Sprite2D) -> void:
    if not sprite:
        return
    
    var tags = ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    
    #if ooga_booga == 'anim_shooting' or ooga_booga == 'anim_head_idle':
     #   tags.erase('x')
     #   tags.erase('y')
    
    var kx: float
    var ky: float
    
    for tag in tags:
        if tag not in animation_frame:
            continue
        
        match tag:
            
            'x': sprite.position.x = animation_frame[tag] #- sprite.get_parent().position.x
            'y': sprite.position.y = animation_frame[tag] #- sprite.get_parent().position.y            
            'sx': sprite.scale.x = animation_frame[tag]
            'sy': sprite.scale.y = animation_frame[tag]
            'kx': 
                # sprite.rotation = deg_to_rad(animation_frame[tag])
                kx = animation_frame[tag]
            'ky':
                ky = animation_frame[tag]
                #if ky == kx:
                #    sprite.rotation = deg_to_rad(kx)
                #else:
                #    sprite.rotation - deg_to_rad(kx)
                #    sprite.skew = deg_to_rad(kx - ky)
                
                sprite.rotation = deg_to_rad(kx)
                sprite.skew = deg_to_rad(ky - kx)
                
            'i':
                if AnimationData.atlas_regions.get(animation_frame[tag]):
                    sprite.texture.region = AnimationData.atlas_regions[animation_frame[tag]]
                
func apply_default_transforms() -> void: # this should be removed at some point when the rest of this script is better
    for animation_name in animations.keys():
        for animation_frame in animations[animation_name]['frames']:
            apply_transforms(animation_frame, find_child(animation_name)) # find child takes lots of cpu juice? so cache it porbably

func compose_transform(translation: Vector2, rotation: float, skew_y: float, scale: Vector2) -> Transform2D: # get y skew
    var t := Transform2D()
    t[0][0] = cos(rotation + skew_y) * scale.x
    t[0][1] = sin(rotation + skew_y) * scale.x
    t[1][0] = -sin(rotation) * scale.y
    t[1][1] = cos(rotation) * scale.y
    t[2] = translation
    return t
