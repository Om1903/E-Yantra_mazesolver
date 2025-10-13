	///*
	//Module HC_SR04 Ultrasonic Sensor
	//
	//This module will detect objects present in front of the range, and give the distance in mm.
	//
	//Input:  clk_50M - 50 MHz clock
	//        reset   - reset input signal (Use negative reset)
	//        echo_rx - receive echo from the sensor
	//
	//Output: trig    - trigger sensor for the sensor
	//        op     -  output signal to indicate object is present.
	//        distance_out - distance in mm, if object is present.
	//*/
	//
	//// module Declaration
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
		
		// Declaration of additional variables used in logic 
		
		reg [2:0] state;
		reg detection;
		reg [15:0] distance;
		reg [19:0] k = 0;
		reg [19:0] l = 0;
		
		// A 5-stage FSM 
		
		localparam DELAY = 0, TRIG_PHASE = 1, MONITOR = 2, OBJECT_DETERMINATION = 3, FINISHED = 4;
		
		// Initialization of variables
		
		initial begin 
			  state = 0;
			  detection = 0;
			  distance = 0;
			  k = 0; 
			  l = 0;
		end	
		
		always @(posedge clk_50M) begin
			if (reset == 0) begin
				state <= 0;
				detection <= 0;
				distance <= 0;
				k <= 0;
				l <= 0;
				trig <= 0;
			end
			
			else begin 
				case (state) 
					
					// Stage 1: Initial Delay 
					
					DELAY: begin
						if (l != 50) begin
							l <= l + 1;
						end
						else begin 
							l <= 0;
							state <= TRIG_PHASE;
						end
					end
					
					// Stage 2: Sending out transmitter signal by setting trig to high
					
					TRIG_PHASE: begin
						trig <= 1;
						if (l != 500) begin
							l <= l + 1;
						end
						else begin 
							l <= 0;
							state <= MONITOR;
							trig <= 0;
						end
					end
					
					// Stage 3: Monitoring and Calculation of Distance 
					
					MONITOR: begin
						if (echo_rx) begin 
							k <= k + 1;
						end
						else begin 
							state <= OBJECT_DETERMINATION;
							distance <= (k * 34) / 10000;	
							k <= 0;
						end
						l <= l + 1;
					end
					
					// Stage 4: Determination of presence of object
					
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
					
					// Stage 5: Waiting before sending the trig signal again
					
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

