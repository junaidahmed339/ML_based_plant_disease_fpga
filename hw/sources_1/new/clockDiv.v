module clockDiv(clk,div,out);
output reg out;
input clk;
input [31:0] div;
reg [31:0] count;
reg inc;
reg outhold;
reg max;
//assign out=outhold;
always@* begin inc=(count>max); max=div>>1;end
always@(posedge clk)
begin
case(inc)
1:begin count=0; out=~out; end
0:begin count=count+1; end
endcase
end
endmodule