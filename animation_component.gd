extends Node2D

var current_animation: String
var start_index: int
var end_index: int

var frame: int
var frame_timer: float
var fps: int = 12

var tracks: Dictionary
 
var image_map = {
    "IMAGE_REANIM_CALTROP_BLINK1": Rect2i(138, 55, 46, 10),  # atlas coords 
    "IMAGE_REANIM_CALTROP_BLINK2": Rect2i(138, 66, 46, 10),
}

func _ready() -> void:
    tracks = ReanimParser.get_all_animation_tracks(PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt")
    play("anim_idle")
    
func play(track_name: String) -> void:
    var track_frames = tracks.get(track_name)
    if track_frames == null:
        return
    #print(track_frames)
    
    var track_start_index: Variant = null
    var track_end_index: Variant = null
    
    var idx = 0
    for frame in track_frames:
        if frame and not track_start_index:
            track_start_index = idx
        if frame or frame is Dictionary:
            track_end_index = idx
    
        idx += 1
        
    #print(track_start_index)
    #print(track_end_index)
    start_index = track_start_index
    end_index = track_end_index
    
    current_animation = track_name


func _process(delta: float) -> void:
    frame_timer += delta
    var frame_duration = 1.0 / fps
    
    if frame_timer > frame_duration:
        frame_timer = 0.0
        frame = wrapi(frame + 1, start_index, end_index + 1)
        # print(frame)
        
        for track_name in tracks.keys():
            var track = tracks[track_name]
            print(track[frame])
            var frame_data = track[frame]
            if frame_data:
                use_frame_data(frame_data, get_node(track_name))
            #for i in range(1, 5):
            #    if tracks['Caltrop_horn' + str(i)] == track:
            #        use_frame_data(frame_data, get_node("spike"  + str(i)))
            # print(frame_data)
        

func use_frame_data(frame_data: Dictionary, sprite: Sprite2D) -> void:
    var tags := ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    # print(sprite.name, " scale: ", frame_data["sx"], ", ", frame_data["sy"])
    for tag in tags:
        if tag in frame_data:

            var data = float(frame_data[tag])
            
            if tag == 'sx':
                sprite.scale.x = data
            if tag == 'sy':
                sprite.scale.y = data
            
            if tag == 'x':
                sprite.position.x = data
            if tag == 'y':
                sprite.position.y = data
            
            if tag == 'kx':
                sprite.rotation = deg_to_rad(data)
            #if tag == 'ky':
            #    pass
            
            if tag == 'i':
                if sprite.name != "anim_blink":
                    return
                
                data = frame_data[tag]
                var rect = image_map[data]
                sprite.region_rect = rect
            
    
