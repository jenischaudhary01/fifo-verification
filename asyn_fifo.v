module fi #(
    parameter width=8,
 parameter depth=32
)
(
input wclk,rclk,
input w_rst,r_rst,
    input [width-1:0]din,
    input w_en,r_en,
    output reg [width-1:0]dout,
    output full,
    output empty
);
localparam addr=$clog2(depth);
reg [width-1:0] mem [depth-1:0];
reg [addr:0] b_wrt,b_rd,qw,qr,sy_wr,sy_rd;
wire [addr:0] g_wrt,g_rd;
btg a1(b_wrt,g_wrt);
btg a2(b_rd,g_rd);
always @(posedge rclk) begin
  if(r_rst) begin
    qw<=6'd0;
    sy_wr<=6'd0;
  end
  else begin
    qw<=g_wrt;
    sy_wr<=qw;
  end
end
always @(posedge wclk) begin
  if(w_rst) begin
    qr<=6'd0;
    sy_rd<=6'd0;
  end
  else begin
    qr<=g_rd;
    sy_rd<=qr;
  end
end
assign empty=(g_rd==sy_wr);
assign full=(g_wrt[5]!=sy_rd[5]&&g_wrt[4]!=sy_rd[4]&&g_wrt[3:0]==sy_rd[3:0]);
always @(posedge wclk) begin
  if(w_rst) begin
    b_wrt<=6'd0;
  end
  else if(!full&&w_en) begin
    mem[b_wrt[4:0]]<=din;
    b_wrt<=b_wrt+1'd1;
  end
end
always @(posedge rclk) begin
  if(r_rst) begin
    b_rd<=6'd0;
  end
  else if(!empty&&r_en) begin
    dout<=mem[b_rd[4:0]];
    b_rd<=b_rd+1'd1;
  end
end
endmodule
module btg(
    input [5:0] b,
    output  [5:0] gray
);
assign gray={b[5],b[5:1]^b[4:0]};
endmodule
