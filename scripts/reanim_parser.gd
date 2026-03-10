extends Node
class_name ReanimParser

# Data structure to hold frame data
class FrameData:
    var x: float = 0.0
    var y: float = 0.0
    var sx: float = 1.0
    var sy: float = 1.0
    var kx: float = 0.0  # skew x
    var ky: float = 0.0  # skew y
    var f: int = -1     # frame index
    var i: String = ""  # image name

# Data structure for a track
class Track:
    var name: String
    var frames: Array = []


static func parse_reanim():
    return
    get_all_animation_tracks(PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt")
    
    # var fps = int(file.get_line().lstrip("<fps>").rstrip("</fps>"))
    
    #var track_content = get_track(content, "anim_face")
    #var frames = get_all_frames(track_content)
    #
    #for frame in frames:
        #var frame_data = get_frame_data(frame)
        #print(frame_data)
    

static func get_track(reanim_content: String, track_name: String) -> String:
    var track_start_index = reanim_content.find("<name>" + track_name + "</name>")
    var trimmed_content = reanim_content.substr(track_start_index)
    var track_end_index = trimmed_content.find("</track>")
    trimmed_content = trimmed_content.substr(0, track_end_index)
    trimmed_content = trimmed_content.substr(("<name>"+track_name+"</name>").length())
    return trimmed_content
    
static func get_all_frames(track_content: String) -> Array[String]:
    var frames: Array[String] = []

    var pos := 0
    while true:
        var start_index = track_content.find("<t>", pos)
        if start_index == -1:
            break
        
        var end_index = track_content.find("</t>", start_index)
        var frame_content :=  track_content.substr(start_index + 3, end_index - start_index - 3)
        
        frames.append(frame_content)
        pos = end_index # + 1
        
    return frames
    
static func get_frame_data(frame: String) -> Dictionary:
    var tags := ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    var frame_data: Dictionary = {}
    
    for tag in tags:
        var tag_string = "<" + tag + ">"
        var tag_end_string = "</" + tag + ">"
        
        var tag_index = frame.find(tag_string)
        if tag_index == -1:
            continue
        var tag_end_index = frame.find(tag_end_string, tag_index)
        var tag_content = frame.substr(tag_index + tag_string.length(), tag_end_index - tag_index - tag_string.length())
        
        frame_data[tag] = tag_content
    
    return frame_data


#static func get_track_frames(track_content: String) -> Array: # remove empty frames
    ##var file := FileAccess.open(animation_file_path, FileAccess.READ)
    ##if not file:
    ##    return
    ##var content = file.get_as_text()
    ### print(content)
    ##var track_content = get_track(content, track_name)
    #var raw_frames = get_all_frames(track_content)
    #
    #var frames = []
    #for frame in raw_frames:
        #frames.append(get_frame_data(frame))
        ## print(get_frame_data(frame))
    #
    #var animation_start_index: Variant = null
    #var animation_end_index: Variant = null
    #var recording: bool = false
    #
    #var idx = -1
    #for frame in frames:
        #idx += 1
        #var f_tag = frame.get("f", null)
        #if not f_tag:
            #continue
        #if f_tag == "0" and animation_start_index == null:
            #animation_start_index = idx
        #elif f_tag == "-1" and animation_end_index == null and animation_start_index != null:
            #animation_end_index = idx
            #
    #if animation_end_index == null:
        #animation_end_index = len(frames) - 1
    #
    #frames = frames.slice(animation_start_index, animation_end_index + 1)
    #for i in range(0, animation_start_index):
        #frames.insert(0, null)
    #for i in range(0, animation_end_index + 1):
        #frames.append(null)
    #
    #return frames
    
    #for frame in frames:
    #    print(frame)

static func get_track_frames(track_content: String) -> Array: # remove empty frames
    #var file := FileAccess.open(animation_file_path, FileAccess.READ)
    #if not file:
    #    return
    #var content = file.get_as_text()
    ## print(content)
    #var track_content = get_track(content, track_name)
    var raw_frames = get_all_frames(track_content)
    
    var frames = []
    for frame in raw_frames:
        frames.append(get_frame_data(frame))
        # print(get_frame_data(frame))
    
    var animation_start_index: Variant = null
    var animation_end_index: Variant = null
    var recording: bool = false
    var new_frames: Array = []
    
    var idx = -1
    for frame in frames:
        idx += 1
        var f_tag = frame.get("f", null)
        if f_tag == "0":
            recording = true
        elif f_tag == "-1":
            recording = false
        
        if recording:
            new_frames.append(frame)
        else:
            new_frames.append(null)
            
    #if animation_end_index == null:
    #    animation_end_index = len(frames) - 1
    
    #frames = frames.slice(animation_start_index, animation_end_index + 1)
    #for i in range(0, animation_start_index):
        #frames.insert(0, null)
    #for i in range(0, animation_end_index + 1):
        #frames.append(null)
    
    return new_frames

    
static func get_file_content(file_path: String) -> Variant:
    var file := FileAccess.open(file_path, FileAccess.READ)
    if file:
        return file.get_as_text()
    else:
        return null
        
static func get_tracks(text: String) -> Array:
    
    var pos = 0
    var tracks := []
    
    while true:
        var start_index = text.find("<track>", pos)
        if start_index == -1:
            break
        var end_index = text.find("</track>", start_index)
        var track_text = text.substr(start_index + 7, end_index - start_index - 7)
        
        tracks.append(track_text)
        pos = end_index
        
        
    return tracks

# the big func
static func get_all_animation_tracks(file_path: String):
    var content: String = get_file_content(file_path)
    var tracks_array: Array = get_tracks(content)
    
    var tracks_dict := {}
    for track in tracks_array:
        var start_idx = track.find("<name>")
        var end_idx = track.find("</name>", start_idx)
        var track_name = track.substr(start_idx + 6, end_idx - start_idx - 6)
        
        tracks_dict[track_name] = track.replace("<name>" + track_name + "</name>", "")
        
    for track_name in tracks_dict.keys():
        tracks_dict[track_name] = get_track_frames(tracks_dict[track_name])
    
    return tracks_dict
    #var t = "anim_blink"
    #print(tracks_dict[t])
    #print(len(tracks_dict[t]))
        
        
    
