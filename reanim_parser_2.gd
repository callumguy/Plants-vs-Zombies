extends Node
class_name ReanimParser2

#static func read_file(path: String) -> String:
#    var file = FileAccess.open(path, FileAccess.READ)
#    return file.get_as_text()

static func parse(file_content: String) -> Dictionary:
    var result = {}
    
    var pos = 0
    while true:
        var track_start = file_content.find("<track>", pos)
        if track_start == -1:
            break
        
        var track_end = file_content.find("</track>", track_start)
        var track_xml = file_content.substr(track_start, track_end - track_start)
        
        var name_start = track_xml.find("<name>") + 6 # 6 for the chars in "<name>"
        var name_end = track_xml.find("</name>")
        var track_name = track_xml.substr(name_start, name_end - name_start)
        
        result[track_name] = {}
        result[track_name]['info'] = {}
        
        var frames = []
        var frame_pos = 0 # pos in string
        var frame_num = 0 # n frame
        while true:
            var frame_start = track_xml.find("<t>", frame_pos)
            if frame_start == -1:
                break
                
            var frame_end = track_xml.find("</t>", frame_start)
            var frame_content = track_xml.substr(frame_start + 3, frame_end - frame_start - 3) # 3 for the chars in "<t>"
            
            var frame_data = parse_frame(frame_content)
            frames.append(frame_data)
            
            # ---
            if 'f' in frame_data:
                if frame_data['f'] == 0:
                    result[track_name]['info']['start_frame'] = frame_num
                else:
                    result[track_name]['info']['end_frame'] = frame_num - 1
            # ---
            frame_pos = frame_end + 1
            frame_num += 1
            
        result[track_name]['frames'] = frames
        
        # ---
        if not result[track_name]['info'].get('start_frame'):
            result[track_name]['info']['start_frame'] = 0
        if not result[track_name]['info'].get('end_frame'):
            result[track_name]['info']['end_frame'] = -1
        
        if result[track_name]['info']['end_frame'] == -1:
            result[track_name]['info']['end_frame'] = frame_num - 1
        # --- 
        pos = track_end + 1
        
    return result

static func parse_frame(frame_xml: String) -> Dictionary:
    var frame = {}
    var tags = ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f', 'i']
    
    for tag in tags:
        var tag_start = frame_xml.find("<" + tag + ">")
        if tag_start == -1:
            continue
        
        var tag_end = frame_xml.find("</" + tag + ">")
        var value = frame_xml.substr(tag_start + tag.length() + 2, tag_end - tag_start - tag.length() - 2)
        
        if tag in ['x', 'y', 'sx', 'sy', 'kx', 'ky', 'f']:
            value = float(value)
        
        frame[tag] = value
        
    return frame if frame else {}
      
#static func ready() -> void:
#    pass
    # var file_content = read_file(PlantData.PLANTS_FOLDER + "Spikeweed/spikeweed_reanim.txt")
    # var result = parse(file_content)
    #print("----- yeah ----")
    #print(result)
    #print("----- yeah ----")

# start frame, end frame, fps,
