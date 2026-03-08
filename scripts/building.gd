extends Node2D

signal tower_placed(selected_tower: PackedScene)

@onready var till_sound: AudioStreamPlayer = $TillSound
@onready var mouse_area: Area2D = $"../mouse_area"
@onready var preview_ghost_sprite: AnimatedSprite2D = $"../PreviewGhost/Sprite"

@onready var shovel_button: TextureButton = $"../CanvasLayer/LevelUI/MarginContainer/HBoxContainer/TopBar/ShovelButton"
@onready var shovel_cursor: Sprite2D = $"../CursorLayer/Shovel"

@onready var currency: Currency = $"../CurrencyComponent"

var selected_tower = null
var towers := []
var is_placing = false
var towers_on_cooldown: Array = []
var is_shovelling = false

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _on_left_click(event)
 
func _on_left_click(event: InputEvent) -> void:
    if mouse_is_under_sun():
        return
    var pos = GameManager.get_grid_position(event.position)
    
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

func place_tower(position: Vector2):
    if selected_tower == null:
        return
    if position == Vector2.ZERO:
        return
    if is_position_occupied(position):
        return
 
    var tower_cost = selected_tower.instantiate().sun_cost
    if not currency.can_afford(tower_cost):
        return
    currency.spend(tower_cost)
    
    var tower = selected_tower.instantiate()
    tower.position = position
    var tower_grid_position = GameManager.get_grid_location(position)
    tower.lane = tower_grid_position.y
    tower.column = tower_grid_position.x
    $"../Towers".add_child(tower)
    towers.append(tower)
    till_sound.play()
    
    emit_signal("tower_placed", selected_tower)
    towers_on_cooldown.append(selected_tower)
    tower.tower_destroyed.connect(_on_tower_destroyed)
    selected_tower = null
    
    is_placing = false
    preview_ghost_sprite.visible = false

func destroy_tower(position: Vector2):
    var tower
    for t in $"../Towers".get_children():
        if t.position == position:
            tower = t
    
    if not tower:
        return
    
    tower.die()
    
func read_seedbar(): 
    for seed_packet in $"../CanvasLayer/LevelUI/MarginContainer/HBoxContainer/LeftBar/SeedBar".get_children():
        if seed_packet is TextureRect:
            continue
        seed_packet.clicked.connect(_on_seed_selected)
        
func _on_seed_selected(scene: PackedScene):
    selected_tower = scene
    is_placing = true
    preview_ghost_sprite.visible = true
    
    var to_preview_sprite = selected_tower.instantiate().find_child("Sprite")
    preview_ghost_sprite.sprite_frames = to_preview_sprite.sprite_frames
    preview_ghost_sprite.scale = to_preview_sprite.scale
    preview_ghost_sprite.position = to_preview_sprite.position
    
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
    print("bue")
    is_shovelling = false
    shovel_cursor.visible = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
    if is_shovelling:
        shovel_cursor.position = get_viewport().get_mouse_position()
            
        
    
