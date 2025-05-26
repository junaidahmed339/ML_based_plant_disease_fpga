module vgaPulse(clk,stage1,stage2,stage3,endStage,syncPulse,free,position);
reg [12:0] count;
reg inc;
reg[10:0] posCount;
output [10:0] position;
assign position=posCount;
input [21:0] stage1,stage2,stage3,endStage;
input clk;
//wether the count is in each stage
reg S0,S1,S2,S3;
output  syncPulse,free;
//free if and only if in stage 0
assign free=fr;
//sync is high if in stage 0 1 or 3
assign syncPulse=sp;

reg fr,sp;
always@*
begin
inc=(count>endStage);
//stage0
S0<=(((count>21'd0)||(count==21'd0))&&(count<stage1)||(count==endStage));
//stage1
S1<=(((count>stage1)||(count==stage1))&&(count<stage2));
//stage2
S2<=(((count>stage2)||(count==stage2))&&(count<stage3));
//stage3
S3<=(((count>stage3)||(count==stage3))&&(count<endStage));
//free if and only if in stage 0
end
always@(negedge clk)
begin
//free if and only if in stage 0
fr<=S2;
//sync is high if in stage 0 1 or 3
sp<=S1||S2||S3;
end
//at the clock edge
always@(posedge clk)
begin
case(free)
0:posCount=0;
1:posCount=posCount+1;
endcase
case(inc)
1:count=0;
0:count=count+1;
endcase
end
endmodule