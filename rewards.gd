extends Node

func split(reward: String) -> Dictionary:
    var split = reward.split("/")
    return {'type': split[0], 'name': split[1]}

func get_texture(reward: String) -> Texture2D:
    var reward_dict = split(reward)
    var texture: Texture2D
    
    if reward_dict['type'] == 'plant':
        texture = AtlasTexture.new()
        texture.atlas = PlantData.ICON_ATLAS_TEXTURE
        texture.region = PlantData.plants[reward_dict['name']]['icon_region']
    
    return texture
