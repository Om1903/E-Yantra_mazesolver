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

wire [6:0] current_index;
reg [2:0] state;
reg [3:0] i;
reg [3:0] j;
reg [1:0] visit_count [0:80];

parameter rows = 9;
parameter columns = 9;
parameter IDLE = 0, FACING_NORTH = 1, FACING_SOUTH = 2, FACING_EAST = 3, FACING_WEST = 4, EXIT_FOUND = 5;

initial begin 
	i = 4;
	j = 8;
	state = IDLE;
end 

assign current_index = j * 9 + i;

always @(posedge clk) begin 
	if (rst_n == 0) begin
		move <= 0;
		state <= IDLE;
	end
	else begin 
		case (state) 
			IDLE: begin				
				move <= 3'd1;
				state <= FACING_NORTH;
			end
			FACING_NORTH: begin
			   if (mid && left && right) begin
					move <= 3'd4;
					j <= j + 1;
					state <= FACING_SOUTH;					
				end
				else if (!left && mid && right) begin
					move <= 3'd2;
					i <= i - 1;
					visit_count[current_index + 9] <= visit_count[current_index + 9] + 1;
					state <= FACING_WEST;
				end
				else if (mid && left && !right) begin
					move <= 3'd3;
					i <= i + 1;
					visit_count[current_index + 9] <= visit_count[current_index + 9] + 1;
					state <= FACING_EAST;
				end				
				else if (!left && mid && !right) begin
					move <= 3'd2;
					i <= i - 1;
					visit_count[current_index + 9] <= visit_count[current_index + 9] + 1;
					state <= FACING_WEST;
				end
				else if (left && !mid && !right) begin	
					move <= 3'd3;
					i <= i + 1;
					visit_count[current_index + 9] <= visit_count[current_index + 9] + 1;
					state <= FACING_EAST;					
				end
				else if (!left && !mid && right) begin
					move <= 3'd2;
					i <= i - 1;
					visit_count[current_index + 9] <= visit_count[current_index + 9] + 1;			
					state <= FACING_WEST;							
				end
				else begin
					move <= 3'd1;
					j <= j - 1;
				end
			end
			FACING_SOUTH: begin
				if (mid && left && right) begin
					move <= 3'd4;
					j <= j - 1;
					state <= FACING_NORTH;
				end
				else if (!left && mid && right) begin
					move <= 3'd2;
					i <= i + 1;
					visit_count[current_index - 9] <= visit_count[current_index - 9] + 1;
					state <= FACING_EAST;
				end
				else if (mid && left && !right) begin
					move <= 3'd3;
					i <= i - 1;
					visit_count[current_index - 9] <= visit_count[current_index - 9] + 1;
					state <= FACING_WEST;
				end				
				else if (!left && mid && !right) begin
					move <= 3'd2;
					i <= i + 1;
					visit_count[current_index - 9] <= visit_count[current_index - 9] + 1;
					state <= FACING_EAST;
				end
				else if (left && !mid && !right) begin	
					move <= 3'd3;
					i <= i - 1;
					visit_count[current_index - 9] <= visit_count[current_index - 9] + 1;
					state <= FACING_WEST;
				end
				else if (!left && !mid && right) begin
					move <= 3'd2;
					i <= i + 1;
					visit_count[current_index - 9] <= visit_count[current_index - 9] + 1;
					state <= FACING_EAST;					
				end
				else begin
					move <= 3'd1;
					j <= j + 1;
				end
			end
			FACING_EAST: begin
				if (mid && left && right) begin
					move <= 3'd4;
					i <= i - 1;
					state <= FACING_WEST;
				end
				else if (!left && mid && right) begin
					move <= 3'd2;
					j <= j - 1;
					visit_count[current_index - 1] <= visit_count[current_index - 1] + 1;
					state <= FACING_NORTH;					
				end
				else if (mid && left && !right) begin
					move <= 3'd3;
					j <= j + 1;
					visit_count[current_index - 1] <= visit_count[current_index - 1] + 1;
					state <= FACING_SOUTH;
				end				
				else if (!left && mid && !right) begin
					move <= 3'd2;
					j <= j - 1;
					visit_count[current_index - 1] <= visit_count[current_index - 1] + 1;
					state <= FACING_NORTH;
				end
				else if (left && !mid && !right) begin	
					move <= 3'd3;
					j <= j + 1;
					visit_count[current_index - 1] <= visit_count[current_index - 1] + 1;
					state <= FACING_SOUTH;					
				end
				else if (!left && !mid && right) begin
					move <= 3'd2;
					j <= j - 1;
					visit_count[current_index - 1] <= visit_count[current_index - 1] + 1;
					state <= FACING_NORTH;					
				end
				else begin
					move <= 3'd1;
					i <= i + 1;
				end
			end
			FACING_WEST: begin				
				if (mid && left && right) begin
					move <= 3'd4;
					i <= i + 1;
					state <= FACING_EAST;
				end
				else if (!left && mid && right) begin
					move <= 3'd2;
					j <= j + 1;
					visit_count[current_index + 1] <= visit_count[current_index + 1] + 1;
					state <= FACING_SOUTH;
				end
				else if (mid && left && !right) begin
					move <= 3'd3;
					j <= j - 1;
					visit_count[current_index + 1] <= visit_count[current_index + 1] + 1;
					state <= FACING_NORTH;
				end				
				else if (!left && mid && !right) begin
					move <= 3'd2;
					j <= j + 1;
					visit_count[current_index + 1] <= visit_count[current_index + 1] + 1;
					state <= FACING_SOUTH;
				end
				else if (left && !mid && !right) begin	
					move <= 3'd3;
					j <= j - 1;
					visit_count[current_index + 1] <= visit_count[current_index + 1] + 1;
					state <= FACING_NORTH;
				end
				else if (!left && !mid && right) begin
					move <= 3'd2;
					j <= j + 1;
					visit_count[current_index + 1] <= visit_count[current_index + 1] + 1;
					state <= FACING_SOUTH;					
				end
				else begin
					move <= 3'd1;
					i <= i - 1;
				end
			end
		endcase
	end
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
