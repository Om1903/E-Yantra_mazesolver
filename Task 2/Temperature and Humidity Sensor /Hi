module t2a_dht(
    input clk_50M,
    input reset,
    inout sensor,
    output reg [7:0] T_integral,
    output reg [7:0] RH_integral,
    output reg [7:0] T_decimal,
    output reg [7:0] RH_decimal,
    output reg [7:0] Checksum,
    output reg data_valid
);

    initial begin
        T_integral = 0;
        RH_integral = 0;
        T_decimal = 0;
        RH_decimal = 0;
        Checksum = 0;
        data_valid = 0;
    end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
reg sensor_dir;

// tri-state logic
reg sensor_out;
reg [5:0] index;               // bit index 0..39
assign sensor = (sensor_dir) ? sensor_out : 1'bz;
wire sensor_in = sensor;       //  input from sensor

// FSM states
parameter S0 = 4'b0000, // S0: start_LOW
          S1 = 4'b0001, // S1: start_HIGH
          S2 = 4'b0010, // S2: response_LOW
          S3 = 4'b0011, // S3: response_HIGH
          S4 = 4'b0100, // S4: read_bit_LOW
          S5 = 4'b0101, // S5: read_bit_HIGH
          S6 = 4'b0110, // S6: Verify checksum 
          S7 = 4'b0111; // S7: Output data

// Slightly reduced each threshold (≈10 cycles) to ensure conditions trigger before sensor_in changes.
parameter start_LOW_thres       = 899990;//start_LOW cycles
parameter start_HIGH_thres      = 1990;  //start_HIGH cycles  
parameter response_LOW_thres    = 3990;  // sensor response low cycles
parameter response_HIGH_thres   = 3990;  // sensor response high cycles
parameter read_bit_LOW_thres    = 2490; // read_bit_LOW cycles 
parameter read_bit_HIGH_thres_1 = 2390; // threshold for logic '1'{(26+70)/2*50}
parameter read_bit_HIGH_thres_0 = 1290; // threshold for logic '0'

reg [3:0]  current_state = 0;
reg [39:0] data_buffer   = 0;   // stores 40 bits read from sensor
reg [31:0] counter       = 0;   // timing counter
reg        data_valid_buffer = 0; // internal  flag

always @(posedge clk_50M) begin
    // Active-low reset
    if (!reset) begin
        current_state     <= S0;
        sensor_out        <= 1'b0;
        T_integral        <= 0;
        RH_integral       <= 0;
        T_decimal         <= 0;
        RH_decimal        <= 0;
        Checksum          <= 0;
        data_valid_buffer <= 0;
        counter           <= 0;
        sensor_dir        <= 0;
        index             <= 0;
    end
    else begin
        case (current_state)

        S0: begin
         
            sensor_dir        <= 1'b1;
            sensor_out        <= 1'b0;
            counter           <= counter + 1;
            data_valid_buffer <= 0;

            if (counter >= start_LOW_thres) begin
             
                current_state <= S1;
                sensor_out    <= 1'b1;
                counter       <= 0;
                sensor_dir    <= 1'b1;
            end
        end

        S1: begin
            
            counter <= counter + 1;
            if (counter >= start_HIGH_thres) begin
                current_state <= S2;
                counter       <= 0;
                sensor_dir    <= 0; 
            end
        end

        S2: begin
            
            if (sensor_in == 0) begin
                counter <= counter + 1;
                if (counter >= response_LOW_thres) begin
                    current_state <= S3;
                    counter       <= 0;
                end
            end
        end

        S3: begin
          
            if (sensor_in == 1) begin
                counter <= counter + 1;
                if (counter >= response_LOW_thres) begin
                    current_state <= S4;
                    counter       <= 0;
                    index         <= 0;
                end
            end
        end

        S4: begin
          
            if (index >= 40) begin
                current_state <= S6;
                counter       <= 0;
            end
            else if (sensor_in == 0) begin
                counter <= counter + 1;
                if (counter >= read_bit_LOW_thres) begin
                    current_state <= S5;
                    counter       <= 0;
                end
            end
        end

        S5: begin
            
            if (sensor_in == 1) begin
               
                counter <= counter + 1;
            end
            else begin
            
                if (index <= 40) begin
                    if (counter >= read_bit_HIGH_thres_1) begin
                        // logical '1'
                        data_buffer[39 - index] <= 1'b1;
                        index <= index + 1;
                        counter <= 0;
                        current_state <= S4;
                    end
                    else if (counter >= read_bit_HIGH_thres_0 && counter <= read_bit_HIGH_thres_1) begin
                        //  logical '0'
                        data_buffer[39 - index] <= 1'b0;
                        index <= index + 1;
                        counter <= 0;
                        current_state <= S4;
                    end
                end
            end
        end

        S6: begin

            if (data_buffer[7:0] == (data_buffer[15:8] + data_buffer[23:16] + data_buffer[31:24] + data_buffer[39:32])) begin
                data_valid_buffer <= 1'b1;
                current_state <= S7;
            end
            else begin
                data_valid_buffer <= 1'b0;
                current_state <= S7;
            end
        end

        S7: begin
            T_integral  <= data_buffer[23:16];
            RH_integral <= data_buffer[39:32];
            T_decimal   <= data_buffer[15:8];
            RH_decimal  <= data_buffer[31:24];
            Checksum    <= data_buffer[7:0];
            current_state <= S0;
            data_valid_buffer <= 0;
        end

        default: begin
            current_state <= S0;
            T_integral <= 0;
            RH_integral <= 0;
            T_decimal <= 0;
            RH_decimal <= 0;
            Checksum <= 0;
            data_valid_buffer <= 0;
        end

        endcase
    end
end


always @(posedge clk_50M) begin
    data_valid <= data_valid_buffer;
end
////////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
