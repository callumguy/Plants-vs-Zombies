extends Node2D

signal tower_placed(selected_tower: PackedScene)

@onready var PLACED_PLANTS_FOLDER := get_node(LevelNodePaths.PLACED_PLANTS_FOLDER_PATH)

@onready var till_sound: AudioStreamPlayer = $TillSound
@onready var mouse_area: Area2D = $"../mouse_area"
# @onready var preview_ghost_sprite: AnimatedSprite2D = $"../PreviewGhost/Sprite"

@onready var shovel_button: TextureButton = $"../CanvasLayer/LevelUI/MarginContainer/HBoxContainer/TopBar/ShovelButton"
@onready var shovel_cursor: Sprite2D = $"../CursorLayer/Shovel"

@onready var currency: Currency = $"../CurrencyComponent"

var selected_packet: SeedPacket

var towers := []
var towers_on_cooldown: Array = []
var is_shovelling = false

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _on_left_click(event)
 
func _on_left_click(event: InputEvent) -> void:
    if mouse_is_under_sun():
        return
    var pos = GridManager.pos_to_grid_pos(event.position)
    
    if is_shovelling:
        destroy_tower(pos)
        disable_shovel()
    else:
        place_tower(pos)


func is_position_occupied(pos: Vector2) -> bool:
    for t in towers:
        if t.position == pos:
            return true
    return false

func place_tower(grid_pos: Vector2):
    print(grid_pos)
    if selected_packet == null or grid_pos == Vector2(-1, -1) or is_position_occupied(GridManager.grid_pos_to_pos(grid_pos)):
        return
    
    if selected_packet.recharge_time_left > 0:
        return
    
    var cost = selected_packet.cost
    if not currency.can_afford(cost):
        return   
    currency.spend(cost)
    
    var tower = selected_packet.scene.instantiate()
    tower.position = GridManager.clamp_pos_to_grid(GridManager.grid_pos_to_pos(grid_pos))
    
    # var grid_pos = GridManager.pos_to_grid_pos(pos) # converts position to grid coords. I.e. (458, 675) -> (2, 3)
    tower.lane = grid_pos.y
    tower.column = grid_pos.x
    
    PLACED_PLANTS_FOLDER.add_child(tower)
    towers.append(tower)
    till_sound.play()
    
    emit_signal("tower_placed", selected_packet.scene)
    # towers_on_cooldown.append(selected_packet.scene)
    tower.tower_destroyed.connect(_on_tower_destroyed)
    
    selected_packet = null
    # preview_ghost_sprite.visible = false

func destroy_tower(position: Vector2):
    var tower
    for t in PLACED_PLANTS_FOLDER.get_children():
        if t.position == position:
            tower = t
    
    if not tower:
        return
    
    tower.die()
    
func read_seedbar(): 
    for battle_packet in $"../CanvasLayer/LevelUI/MarginContainer/HBoxContainer/LeftBar/SeedBar".get_children():
        if not battle_packet is BattlePacket: #TextureRect:
            continue
        battle_packet.clicked.connect(_on_packet_clicked)
        
func _on_packet_clicked(battle_packet: BattlePacket):
    if selected_packet == battle_packet:
        selected_packet = null
        return
    
    selected_packet = battle_packet
    #preview_ghost_sprite.visible = true
    
    #var to_preview_sprite = selected_tower.instantiate().find_child("Sprite")
    #preview_ghost_sprite.sprite_frames = to_preview_sprite.sprite_frames
    #preview_ghost_sprite.scale = to_preview_sprite.scale
    #preview_ghost_sprite.position = to_preview_sprite.position
    
func _ready() -> void:
    shovel_button.clicked.connect(_shovel_button_clicked)

func _on_tower_destroyed(tower):
    towers.erase(tower)
    
func mouse_is_under_sun():
    for area in mouse_area.get_overlapping_areas():
        if area.is_in_group("sun"):
            return true
    
    return false
    
func _shovel_button_clicked() -> void:
    if is_shovelling:
        disable_shovel()
    else:
        enable_shovel()

func enable_shovel():
    is_shovelling = true
    shovel_cursor.visible = true
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    
func disable_shovel():
    is_shovelling = false
    shovel_cursor.visible = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
    if is_shovelling:
        shovel_cursor.position = get_viewport().get_mouse_position()
            
        
    
