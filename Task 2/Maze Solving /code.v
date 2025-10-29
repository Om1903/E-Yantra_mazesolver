// Task 2C - MazeSolver Bot

module t2c_maze_explorer (
    input clk,
    input rst_n,
    input left, mid, right, // 0 - no wall, 1 - wall
    output reg [2:0] move
);

/*

| cmd | move  | meaning   |
|-----|-------|-----------|
| 000 | 0     | STOP      |
| 001 | 1     | FORWARD   |
| 010 | 2     | LEFT      |
| 011 | 3     | RIGHT     | 
| 100 | 4     | U_TURN    |

START POS   : 4,0
EXIT POS    : 4,8
DEADENDS    : 9

*/
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [1:0] state;
reg [1:0] dir;
reg [6:0] k;
reg [6:0] next_left;
reg [6:0] next_right;
reg [6:0] next_straight;
reg [6:0] next_back;
reg [6:0] current_index;
reg [6:0] next_index;

reg [1:0] visit_count [0:80];

parameter IDLE = 0, DECIDE = 1, MAKE_MOVE = 2;
parameter NORTH = 0, SOUTH = 1, EAST = 2, WEST = 3;

initial begin 
    for (k = 0; k < 81; k = k + 1) begin
        visit_count[k] = 0;
    end
end
always @(*) begin
    case (dir)
        NORTH: begin
            next_straight = current_index - 9;   
            next_left     = current_index - 1;   
            next_right    = current_index + 1;
            next_back     = current_index + 9;   
         end
        
        SOUTH: begin
            next_straight = current_index + 9;   
            next_left     = current_index + 1;  
            next_right    = current_index - 1;  
            next_back     = current_index - 9; 
        end

        EAST: begin
            next_straight = current_index + 1;   
            next_left     = current_index - 9;   
            next_right    = current_index + 9;  
            next_back     = current_index - 1;
        end

        WEST: begin
            next_straight = current_index - 1;   
            next_left     = current_index + 9;   
            next_right    = current_index - 9;  
            next_back     = current_index + 1; 
        end
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        move <= 0;
        current_index <= 76;
        state <= IDLE;
        dir <= NORTH;
    end
    else begin 
        case (state) 
            IDLE: begin
                move <= 0;
                state <= DECIDE;
            end
            DECIDE: begin
                visit_count[current_index] <= visit_count[current_index] + 1;
                if (mid && left && right) begin
                    move <= 4; 
                    next_index <= next_back;
                end
                else if (mid && right && !left) begin
                    move <= 2;
                    next_index <= next_left;
                end
                else if (mid && left && !right) begin
                    move <= 3;
                    next_index <= next_right;
                end
                else if (left && right && !mid) begin
                    move <= 1;
                    next_index <= next_straight;
                end
                else if (right && !left && !mid) begin
                    if (visit_count[next_left] == 0) begin
                        move <= 2; 
                        next_index <= next_left;
                    end else begin
                        move <= 1;
                        next_index <= next_straight;
                    end
                end
                else if (left && !right && !mid) begin
                    if (visit_count[next_right] == 0) begin
                        move <= 3; 
                        next_index <= next_right;
                    end else begin
                        move <= 1; 
                        next_index <= next_straight;
                    end
                end
                else if (mid && !left && !right) begin
                    if (visit_count[next_left] == 0) begin
                        move <= 2; 
                        next_index <= next_left;
                    end else begin
                        move <= 3;
                        next_index <= next_right;
                    end
                end
                state <= MAKE_MOVE;
            end
            MAKE_MOVE: begin
                case (move)
                    1: begin 
                        current_index <= next_index;
                    end
                    2: begin 
                        current_index <= next_index;                       
                        case (dir)
                            NORTH: dir <= WEST;
                            WEST:  dir <= SOUTH;
                            SOUTH: dir <= EAST;
                            EAST:  dir <= NORTH;
                        endcase
                    end
                    3: begin 
                        current_index <= next_index;
                        case (dir)
                            NORTH: dir <= EAST;
                            EAST:  dir <= SOUTH;
                            SOUTH: dir <= WEST;
                            WEST:  dir <= NORTH;
                        endcase
                    end
                    4: begin 
                        current_index <= next_index;
                        case (dir)
                            NORTH: dir <= SOUTH;
                            SOUTH: dir <= NORTH;
                            EAST:  dir <= WEST;
                            WEST:  dir <= EAST;
                        endcase
                    end
                endcase
                state <= DECIDE;
            end
        endcase
    end
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
