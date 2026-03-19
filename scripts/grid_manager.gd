extends Node

const WINDOW_WIDTH := 1000
const WINDOW_HEIGHT := 600

const LAWN_LEFT := 250
const LAWN_TOP := 75
const LAWN_WIDTH := 735
const LAWN_HEIGHT := 500

const HOUSE_X: int = 200 # x if zombie gets to this x-position, player loses

var number_of_lanes: int = 5
var number_of_columns: int = 9

var cell_width: float = LAWN_WIDTH / number_of_columns
var cell_height: float = LAWN_HEIGHT / number_of_lanes

func set_grid_size(number_of_lanes: int, number_of_columns:int) -> void:
    number_of_lanes = number_of_lanes
    number_of_columns = number_of_columns
    cell_width = LAWN_WIDTH / number_of_columns
    cell_height = LAWN_HEIGHT / number_of_lanes



func pos_to_grid_pos(pos: Vector2) -> Vector2:
    if pos.x < LAWN_LEFT or pos.x >= LAWN_LEFT + LAWN_WIDTH:
        return Vector2(-1, -1)
    if pos.y < LAWN_TOP or pos.y >= LAWN_TOP + LAWN_HEIGHT:
        return Vector2(-1, -1)
    
    pos -= Vector2(LAWN_LEFT, LAWN_TOP)
    var grid_pos_x = floor(pos.x / cell_width)
    grid_pos_x = clamp(grid_pos_x, 0, number_of_columns)
    
    var grid_pos_y = floor(pos.y / cell_height)
    grid_pos_y = clamp(grid_pos_y, 0, number_of_lanes)
    
    return Vector2(grid_pos_x, grid_pos_y)

func grid_pos_to_pos(pos: Vector2) -> Vector2:
    return Vector2(
        LAWN_LEFT + pos.x * cell_width + cell_width / 2,
        LAWN_TOP + pos.y * cell_height + cell_height / 2
        )
        
func clamp_pos_to_grid(pos: Vector2) -> Vector2:
    var grid_pos = pos_to_grid_pos(pos)
    var clamped_pos = grid_pos_to_pos(grid_pos)
    return clamped_pos

#func cell_center(col: int, lane: int):
#    return Vector2(
#        LAWN_LEFT + col * cell_width + cell_width / 2,
#        lane_y(lane)
 #   )
