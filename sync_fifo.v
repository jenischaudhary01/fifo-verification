module fifo #(
    parameter fifo_width =8,
    parameter fifo_depth =32 
)
(
    input clk,reset,
    input [fifo_width-1:0]data,
    input wrt,red,
output reg [fifo_width-1:0]data_out,
output full,empty
);
localparam addr_width =$clog2(fifo_depth) ;
reg [fifo_width-1:0]memory[fifo_depth-1:0];
reg [addr_width-1:0]wrt_ptr,red_ptr;
reg [addr_width:0]depth_ptr;
assign full=(depth_ptr==fifo_depth)?1:0;
assign empty=(depth_ptr=='h0)?1:0;
always @(posedge clk) begin
    if(reset)begin
      wrt_ptr<='h0;
    end
    else begin
      if(wrt&& !full)begin
        memory[wrt_ptr]<=data;
        wrt_ptr<=wrt_ptr+1;
      end
    end
end
always @(posedge clk) begin
    if(reset)begin
      red_ptr<='h0;
    end
    else begin
      if(red&& !empty)begin
        data_out<=memory[red_ptr];
        red_ptr<=red_ptr+1;
      end
    end
end
always @(posedge clk)begin
  if(reset) begin
    depth_ptr<='h0;
  end
  else begin
 case({wrt&&!full,red&&!empty})
 2'b10:depth_ptr<=depth_ptr+1;
 2'b01:depth_ptr<=depth_ptr-1;
 default : depth_ptr<=depth_ptr;
 endcase
  end
end
endmodule
