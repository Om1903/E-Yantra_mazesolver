module uart_tx(
    input clk_3125,
    input parity_type,
    input tx_start,
    input [7:0] data,
    output reg tx,
    output reg tx_done
);

initial begin
    tx = 1'b1;      
    tx_done = 1'b0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

localparam S_IDLE   = 3'b000;
localparam S_START  = 3'b001;
localparam S_DATA   = 3'b010;
localparam S_PARITY = 3'b011;
localparam S_STOP   = 3'b100;

localparam BIT_DURATION = 27;

reg [2:0] state = S_IDLE;
reg [4:0] clk_counter = 0;
reg [2:0] bit_counter = 0;
reg [8:0] tx_buffer;

// This combinational block is fine, it just prepares data
reg calculated_parity;
always@(*) begin
    calculated_parity = (parity_type == 1'b0) ? (^data) : (~^data);
    tx_buffer = {data, calculated_parity};
end

// The main FSM with "look-ahead" registered outputs
always @(posedge clk_3125) begin
    
    // Default action: tx_done is a pulse, so it's almost always low.
    tx_done <= 1'b0;

    case (state)
        S_IDLE: begin
            clk_counter <= 0;
            bit_counter <= 0;
            tx <= 1'b1; // Keep the line high

            if (tx_start) begin
                state <= S_START;
                // LOOK-AHEAD: Next state is S_START, its output is 0 (Start Bit)
                tx <= 1'b0;
            end
        end

        S_START: begin
            if (clk_counter < BIT_DURATION - 1) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                state <= S_DATA;
                // LOOK-AHEAD: Next state is S_DATA, its output is the first data bit
                tx <= tx_buffer[8]; // MSB of data
            end
        end

        S_DATA: begin
            if (clk_counter < BIT_DURATION - 1) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
            
                if (bit_counter < 7) begin
                    bit_counter <= bit_counter + 1;
                    state <= S_DATA; // Staying in S_DATA
                    // LOOK-AHEAD: Output will be the *next* data bit
                    tx <= tx_buffer[8 - (bit_counter + 1)];
                end else begin
                    bit_counter <= 0;
                    state <= S_PARITY;
                    // LOOK-AHEAD: Next state is S_PARITY, its output is the parity bit
                    tx <= tx_buffer[0];
                end
            end
        end
        
        S_PARITY: begin
            if (clk_counter < BIT_DURATION - 1) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                state <= S_STOP;
                // LOOK-AHEAD: Next state is S_STOP, its output is 1 (Stop Bit)
                tx <= 1'b1;
//                tx_done <= 1'b1;
            end
        end

        S_STOP: begin
            if (clk_counter < BIT_DURATION - 2) begin
                clk_counter <= clk_counter + 1;
            end 
				else begin
                clk_counter <= 0;
                state <= S_IDLE;
                // Next state is S_IDLE, its output is 1
                tx <= 1'b1;
                // This is the one moment tx_done should be high
                tx_done <= 1'b1;
            end
        end

        default: begin
            state <= S_IDLE;
            tx <= 1'b1;
        end
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////
endmodule
