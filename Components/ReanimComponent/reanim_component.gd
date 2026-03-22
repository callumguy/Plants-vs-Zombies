extends Node2D
class_name ReanimComponent

signal animation_finished(animation_name: String)

@export_file("*.txt") var reanim_path: String = PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt"

var actor
var animations: Dictionary
var current_animations: Array = []

var sprite_property_changes_this_frame: Dictionary

func _ready() -> void:
    visible = false
    actor = get_parent()
    var content = FileAccess.get_file_as_string(reanim_path)
    animations = ReanimParser2.parse(content)
    apply_default_transforms()

func play(anim_name: String, loop: bool = false, speed_mult: float = 1.0, custom_start_frame: int = -1): # make it so if played with loop=true it overrides the non looper and vise-versa
    var anim = animations.get(anim_name)
    if not anim:
        return
    for current_animation in current_animations:
        if anim_name == current_animation['name']:
            return
        
    var anim_info: Dictionary = {}
    anim_info['fps'] = 12
    anim_info['delta_count'] = 0.0
    
    anim_info['name'] = anim_name
    anim_info['start_frame'] = animations[anim_name]['info']['start_frame']
    if custom_start_frame == -1:
        anim_info['current_frame'] = anim_info['start_frame'] -1 # no start frame given so set to the default
    else:
        anim_info['current_frame'] = custom_start_frame -1 # start midway through the animation
    anim_info['end_frame'] = animations[anim_name]['info']['end_frame']
    # anim_info['current_frame'] = animations[anim_name]['info']['start_frame']
    anim_info['looping'] = loop
    anim_info['speed_mult'] = speed_mult
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
    sprite_property_changes_this_frame = {}
    print(current_animations)
    
    for anim_info in current_animations:
        #print(anim_info['name'])
        anim_info['delta_count'] += delta
        if anim_info['delta_count'] < (1.0 / anim_info['fps'] / anim_info['speed_mult']):
            continue # it's not time for this animations next frame yet
        anim_info['delta_count'] -= (1.0 / anim_info['fps'] / anim_info['speed_mult'])
        
        var was = anim_info['current_frame'] # mmm
        anim_info['current_frame'] = wrapi(anim_info['current_frame'] + 1, anim_info['start_frame'], anim_info['end_frame'])
        var _is = anim_info['current_frame'] # mmm
        #print(was)
        #print(_is)
        
        # print(anim_info['current_frame'])
        #print("---")
        #print(current_animations)
        #print(anim_info)
        for animation_name in animations.keys():
            var animation_frame = animations[animation_name]['frames'][anim_info['current_frame']]
            # print(animation_name, " ", animation_frame)
            apply_transforms(animation_frame, animation_name) # find child takes lots of cpu juice? so cache it porbably
        
        visible = true
        
        if _is < was and not anim_info['looping']: # mmm
            stop(anim_info['name']) # mmm
            continue # mmm
    
func apply_transforms(animation_frame: Dictionary, animation_name: String) -> void:
    var sprite = find_child(animation_name, false, false)
    if not sprite:
        sprite = Sprite2D.new()
        sprite.name = animation_name
        sprite.centered = false
        add_child(sprite)
    
    if not sprite_property_changes_this_frame.get(animation_name):
        sprite_property_changes_this_frame[animation_name] = []
    
    var tags = ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    
    var kx: float
    var ky: float
    
    for tag in tags:
        if tag not in animation_frame:
            continue
        if tag in sprite_property_changes_this_frame[animation_name]: # if sprite has had a property already changed this frame by another anim track, it doesnt change it again
            continue
        sprite_property_changes_this_frame[animation_name].append(tag)
        
        match tag:
            'x': sprite.position.x = animation_frame[tag] #- sprite.get_parent().position.x
            'y': sprite.position.y = animation_frame[tag] #- sprite.get_parent().position.y            
            'sx': sprite.scale.x = animation_frame[tag]
            'sy': sprite.scale.y = animation_frame[tag]
            'kx': kx = animation_frame[tag]
            'ky':
                ky = animation_frame[tag]
                sprite.rotation = deg_to_rad(kx)
                sprite.skew = deg_to_rad(ky - kx)
            'i':
                # if AnimationData.atlas_regions.get(animation_frame[tag]):
                # sprite.texture.region = AnimationData.atlas_regions[animation_frame[tag]]
                var image
                # print(Cache.reanim_image_paths)
                if animation_frame[tag] in Cache.reanim_image_paths:
                    image = Cache.reanim_image_paths.get(animation_frame[tag])
                else:
                    image = AnimationData.get_reanim_image(animation_frame[tag])
                    Cache.reanim_image_paths[animation_frame[tag]] = image
                if image != null:
                    sprite.texture = image
            'f':
                if animation_frame[tag] == 0:
                    sprite.visible = true
                else:
                    sprite.visible = false
            
            
func apply_default_transforms() -> void: # this should be removed at some point when the rest of this script is better
    return
    for animation_name in animations.keys():
        print(animation_name)
        #for track in animations[animation_name]:
        #    pass
        
        var start_frame_index = animations[animation_name]['info']['start_frame']
        print(start_frame_index)
        var frame = animations[animation_name]['frames'][start_frame_index]
        print(frame)
        apply_transforms(frame, animation_name) # find child takes lots of cpu juice? so cache it porbably
