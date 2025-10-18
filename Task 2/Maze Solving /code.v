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
parameter IDLE = 0, MOVE_FORWARD = 1, 

always @(posedge clk) begin 
	if (rst_n == 0) begin
		move <= 0;
		state <= IDLE;
	end
	else begin 
		
	end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
