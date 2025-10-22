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

reg [2:0] state;


parameter rows = 9;
parameter columns = 9;
parameter IDLE = 0, CONDITIONS = 1, MOVE_BACK = 2, TURN_LEFT = 3, TURN_RIGHT = 4;

always @(posedge clk) begin 
	if (rst_n == 0) begin
		move <= 0;
		state <= IDLE;
	end
	else begin 
		case (state) 
			IDLE: begin				
				move <= 3'd1;
				state <= CONDITIONS;
			end
			CONDITIONS: begin
			   if (mid && left && right) begin
					move <= 3'd4;
					state <= MOVE_BACK;
				end
				else if (mid && right) begin
					move <= 3'd2;
					state <= TURN_LEFT;
				end
				else if (mid && left) begin
					move <= 3'd3;
					state <= TURN_RIGHT;
				end				
				else if (mid) begin
					move <= 3'd2;
					state <= TURN_LEFT;
				end
				else if (left) begin
					move <= 3'd3
					state <= TURN_RIGHT;
				end
				else if (right) begin
					move <= 3'd2;
					state <= TURN_LEFT;
				end
				else begin
					move <= 3'd1;
				end
			end
			TURN_LEFT: begin
				move <= 3'd1;
				state <= CONDITIONS;				
			end
			TURN_RIGHT: begin
				move <= 3'd1;
				state <= CONDITIONS;				
			end
			MOVE_BACK: begin				
				move <= 3'd1;
				state <= CONDITIONS;
			end
		endcase
	end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
