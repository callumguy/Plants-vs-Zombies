extends Node

const window_width := 1000
const window_height := 600

const number_of_lanes := 5
const number_of_columns := 9

const LAWN_LEFT := 250
const LAWN_TOP := 75
const LAWN_WIDTH := 735
const LAWN_HEIGHT := 500

const CELL_WIDTH := LAWN_WIDTH / number_of_columns
const CELL_HEIGHT := LAWN_HEIGHT / number_of_lanes

const HOUSE_X := 200

func lane_y(lane: int):
    return LAWN_TOP + lane * CELL_HEIGHT + CELL_HEIGHT / 2

func get_grid_location(location: Vector2): # positions to grid positions. like (453, 612) -> (2, 7)
    location -= Vector2(LAWN_LEFT, LAWN_TOP)
    var grid_x = floor(location.x / CELL_WIDTH)
    var grid_y = floor(location.y / CELL_HEIGHT)
    
    return Vector2(grid_x, grid_y)

func cell_center(col: int, lane: int):
    return Vector2(
        LAWN_LEFT + col * CELL_WIDTH + CELL_WIDTH / 2,
        lane_y(lane)
    )

func get_grid_position(pos: Vector2):

    if pos.x < LAWN_LEFT or pos.x >= LAWN_LEFT + LAWN_WIDTH:
        return Vector2.ZERO
    if pos.y < LAWN_TOP or pos.y >= LAWN_TOP + LAWN_HEIGHT:
        return Vector2.ZERO
    
    var col = floor((pos.x - LAWN_LEFT) / CELL_WIDTH)
    var lane = floor((pos.y - LAWN_TOP) / CELL_HEIGHT)
    
    col = clamp(col, 0, number_of_columns - 1)
    lane = clamp(lane, 0, number_of_lanes - 1)
    
    return cell_center(col, lane)
