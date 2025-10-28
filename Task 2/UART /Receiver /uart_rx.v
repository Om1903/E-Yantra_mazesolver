
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

initial begin
    rx_msg = 8'b0;
    rx_parity = 1'b0;
    rx_complete = 1'b0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

parameter S_IDLE=3'b000;
parameter S_START=3'b001;
parameter S_MSG =3'b010;
parameter S_PARITY = 3'b011;
parameter S_STOP =  3'b100 ;
reg [2:0]current_state= S_IDLE;
reg [8:0] rx_buffer=9'b0;

integer BIT_DURATION=27;
integer clk_counter=0;
integer bit_counter = 0;

always@(posedge clk_3125)
begin
case(current_state)
S_IDLE:  begin
//     rx_msg<=0;
//     rx_parity<=0;
//     rx_complete<=0;
//     clk_counter=0;
//      bit_counter = 0;
//     if(rx==0)  begin
     current_state<=S_START;
     end
//     end
     
     
 S_START : begin
 rx_complete<=0;
//  clk_counter=0;
   bit_counter = 0;
 if(rx==0) begin
//  rx_complete<=0;
  bit_counter = 0;
 if(clk_counter < BIT_DURATION-2) begin
 clk_counter = clk_counter + 1 ;
 end 
 else begin
 clk_counter = 0 ;
 current_state <= S_MSG ;
 end
 end
 end
 
 S_MSG : begin 
// clk_counter=clk_counter+1;
  if(clk_counter == (BIT_DURATION -1)/2 ) begin
  current_state <= S_PARITY ;
  rx_buffer[8] <= rx;
  clk_counter=0;
  bit_counter=1;
  end
  else begin
  clk_counter= clk_counter +1 ;
  end
 


 
 end
 
S_PARITY: 
begin
if(bit_counter<9)begin
if(clk_counter < BIT_DURATION-1) begin
clk_counter = clk_counter+1;
end 
else begin
rx_buffer[8-bit_counter]<=rx;
bit_counter=bit_counter+1;
clk_counter=0;
end
//current_state<=S_MSG;
end
else begin
if(clk_counter <= (BIT_DURATION-1)/2-1)begin
clk_counter = clk_counter +1 ;
end
else begin
current_state <= S_STOP ;
clk_counter = 0;
end
end
end

S_STOP:

begin
if(clk_counter < BIT_DURATION-1) begin
clk_counter = clk_counter+1;
end
else begin
if(rx_buffer[0]==^rx_buffer[8:1]) begin
rx_msg<= rx_buffer[8:1];
rx_parity<=rx_buffer[0];
rx_complete<=1'b1;
end
else begin
rx_msg<= 8'h3F;
rx_parity<=rx_buffer[0];
rx_complete<=1'b1;
end
current_state<= S_START;
clk_counter = 0;
end
end

 endcase

end
/* Add your logic here */

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
