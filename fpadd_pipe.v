module fpadd_pipe (
     input [31:0] a,
     input [31:0] b,
     input clk,
     output[31:0] out);

wire [7:0] e1 ,e2 ,ex ,ey ,exy ,ex1 ,ey1 ,ex2 ,ex3 ;
wire s1 ,s2 ,s ,s3 ,sr ,sn ,s4 ,sx1 ,sy1 ,sn1 ,sn2 ,sn3 ,sn4 ,sr1 ,sr2 ,sn5 ,sn6 ;
wire [23:0]m1 ,m2 ,mx ,my ,mxy ,mx1 ,my1 ;
wire [24:0]mxy1 ,mxy2 ;

assign s1 = a[31];
assign s2 = b[31];
assign e1 = a[30:23];
assign e2 = b[30:23];
assign m1 [23] =  1'b1;
assign m2 [23] = 1'b1;
assign m1 [22:0] = a[22:0];
assign m2 [22:0] = b[22:0];

//submodule for compare and shfit
cmpshift as(e1 [7:0],e2 [7:0],s1 ,s2 ,m1 [23:0],m2 [23:0],clk,ex ,ey ,mx ,my ,s ,sx1,sy1);
buffer1 buff1(ex ,ey ,sx1 ,sy1 ,mx ,my ,s ,clk,ex1 ,ey1 ,mx1 ,my1 ,sn ,sn1 ,sn2 );

//sub module for mantissa addition snd subtraction
faddsub as1(mx1 ,my1 ,sn1 ,sn2 ,sn ,ex1 ,clk ,mxy1 ,ex2 ,sn3 ,sn4 ,s3 ,sr1 );
buffer2 buff2(mxy1 ,s3 ,sr1 ,ex2 ,sn3 ,sn4 ,clk ,mxy2 ,ex3 ,sn5 ,sn6 ,s4 ,sr2 );

//sub module for normalization
normalized as2(mxy2 ,sr2 ,sn5 ,sn6 ,s4 ,clk ,ex3 ,sr ,exy ,mxy );

assign out = {sr ,exy ,mxy [22:0]};
endmodule

module buffer2(
    input [24:0] mxy1,
    input s3,
    input clk,
    input sr1,
    input sn3,
    input sn4,
    input [7:0] ex,
    output reg [24:0] mxy2,
    output reg [7:0] ex3,
    output reg s4,
    output reg sn5,
    output reg sn6,
    output reg sr2
) ;
always@(posedge clk) begin
    sr2  = sr1 ;
    sn5  = sn3 ;
    sn6  = sn4 ;
    ex3  = ex ;
    mxy2  = mxy1 ;
    s4  = s3 ;
end
endmodule

module buffer1(
    input [7:0] ex,
    input [7:0] ey,
    input [23:0] mx,
    input [23:0] my,
    input s,
    input clk,
    input sx1,
    input sy1,
    output reg [7:0] ex1,
    output reg [7:0] ey1,
    output reg [23:0] mx1,
    output reg [23:0] my1,
    output reg sn,
    output reg sn1,
    output reg sn2
) ;
always@(posedge clk) begin
    sn1  = sx1 ;
    sn2  = sy1 ;
    ex1  = ex ;
    ey1  = ey ;
    mx1  = mx ;
    my1  = my ;
    sn  = s ;
end
endmodule

module normalized(
    input [24:0] mxy1,
    input s,
    input s1,
    input s2,
    input s3,
    input clk,
    input [7:0] ex,
    output reg sr,
    output reg [7:0] exy,
    output reg [23:0] mxy);

    reg [24:0] mxy2;

    always@(posedge clk) begin
    sr   = s ? s1 ^ (mxy1[24] & s3 ):s2 ^ (mxy1[24] & s3 );
    mxy2 = (mxy1[24] & s3) ? ~mxy1 + 25'b1 : mxy1;
    mxy  = mxy2 [24:1];
    exy  = ex ;
    repeat(24) begin
        if(mxy [23] == 1'b0) begin
            mxy = mxy << 1'b1;
            exy = exy - 8'b1;
        end
    end
end
endmodule

module faddsub(
    input [23:0] a,
    input [23:0] b,
    input [7:0] ex1,
    input s1,
    input s2,
    input clk,
    input sn,
    output reg [7:0] ex2,
    output reg[24:0] out,
    output reg s ,
    output reg sn3,
    output reg sn4,
    output reg sr1
);
//submodule for addition or subtraction
always@(posedge clk) begin
    ex2 = ex1 ;
    sr1 = sn ;
    sn3 = s1 ;
    sn4 = s2 ;
    s = s1 ^s2 ;
    if(s ) begin
        out = a - b;
    end else begin
        out = a + b;
    end
end
endmodule

module cmpshift (
    input [23:0] m1,
    input [23:0] m2,
    input clk,
    input s1,
    input s2,
    output reg [7:0] ex,
    output reg [7:0] ey,
    output reg [23:0] mx,
    output reg [23:0] my,
    output reg s,
    output reg sx1,
    output reg sy1
);
//module for copare &shift
reg [7:0]diff ;
always@(posedge clk) begin
    sx1  = s1 ;
    sy1  = s2 ;
    if(m1 == m2 ) begin
        ex = m1 +8'b1;
        ey = m2 +8'b1;
        mx = m1 ;
        my = m2 ;
        s  = 1'b1;
    end
    else if(m1 >m2 ) begin
        diff  = m1 - m2;
        ex  = m1 + 8'b1;
        ey  = m1 + 8'b1;
        mx  = m1 ;
        my  = m2 >> diff;
        s  = 1'b1;
    end else begin
        diff  = m2 - m1;
        mx  = m2 + 8'b1;
        my  = m2 + 8'b1;
        mx  = m2;
        my  = m1 >> diff;
        s   = 1'b0;
end
end
endmodule

