/*
Module HC_SR04 Ultrasonic Sensor

This module will detect objects present in front of the range, and give the distance in mm.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (Use negative reset)
        echo_rx - receive echo from the sensor

Output: trig    - trigger sensor for the sensor
        op     -  output signal to indicate object is present.
        distance_out - distance in mm, if object is present.
*/

// module Declaration
module t1b_ultrasonic(
    input clk_50M, reset, echo_rx,
    output reg trig,
    output op,
    output wire [15:0] distance_out
);

initial begin
    trig = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

	reg [2:0] state;
	reg detection;
	reg [15:0] distance;
	integer i = 0;
	integer j = 0;
	integer k = 0;
	integer l = 0;
	localparam DELAY = 0, TRIG_PHASE = 1, MONITOR = 2, CALCULATION = 3, OBJECT_DETERMINATION = 4, FINISHED = 5;
	
	initial begin 
	    state = 0;
        detection = 0;
        distance = 0;
        i = 0;
        j = 0;
        k = 0; 
        l = 0;
	end
	always @(posedge clk_50M) begin
		if (reset == 0) begin
			state <= 0;
			detection <= 0;
			distance <= 0;
			i <= 0;
			j <= 0;
			k <= 0;
			l <= 0;
			trig <= 0;
		end
		
		else begin 
			case (state) 
				DELAY: begin
					if (i != 50) begin
						i <= i + 1;
					end
					else begin 
						i <= 0;
						state <= TRIG_PHASE;
					end
				end
				TRIG_PHASE: begin
					trig <= 1;
					if (j != 500) begin
						j <= j + 1;
					end
					else begin 
						j <= 0;
						state <= MONITOR;
						trig <= 0;
					end
				end
				MONITOR: begin
					if (echo_rx) begin 
						k <= k + 1;
					end
					else begin 
						state <= CALCULATION;
						distance <= (k * 34) / 10000;	
					end
					l <= l + 1;
				end
				CALCULATION: begin
	
					k <= 0;
					state <= OBJECT_DETERMINATION;
					l = l + 1;
				end
				OBJECT_DETERMINATION: begin
					if (distance <= 16'd70) begin
						detection <= 1;
					end
					else begin 
						detection <= 0;
					end
					l = l + 1;
					state <= FINISHED;
				end
				FINISHED: begin
					if (l != 600001) begin
						l <= l + 1;
					end
					else begin 
						l <= 0;
						state <= DELAY;
					end
				end
			endcase
		end 
	end	
	
	assign distance_out = distance;
	assign op = detection;
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
