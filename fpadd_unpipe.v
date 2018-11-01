module fpadd_unpipe(a_x40, b_x40, out_x40);
input[31:0] a_x40, b_x40;
output reg [31:0] out_x40;

reg [7:0]e1_x40, e2_x40, exy_x40;
reg s1_x40, s2_x40, sr_x40, sign_x40;
reg [23:0] m1_x40, m2_x40, mx_x40, my_x40;
reg [24:0] mx_x40y, mx_x40y2;
reg [7:0] diff_x40;

always @ (a_x40 or b_x40) begin
// Splitting A and B into sign, exponent and mantissa
    s1_x40       = a_x40[31];
    s2_x40       = b_x40[31];
    e1_x40       = a_x40[30:23];
    e2_x40       = b_x40[30:23];
    m1_x40[23]   = 1'b1;
    m2_x40[23]   = 1'b1;
    m1_x40[22:0] = a_x40[22:0];
    m2_x40[22:0] = b_x40[22:0];
//Comparing exponent, Assign x seies the higher number.
//Comparing exponent to find difference between them to
//- adjusting mantissa
//- exponent by adding 127
    
    if(e1_x40 == e2_x40) begin
        mx_x40   = m1_x40;
        my_x40   = m2_x40;
        exy_x40  = e1_x40+1'b1;
        sign_x40 = s1_x40;
    end else if(e1_x40 > e2_x40) begin
        diff_x40 = e1_x40 - e2_x40;
        mx_x40   = m1_x40;
        my_x40   = m2_x40>>diff_x40;
        exy_x40  = e1_x40+1'b1;
        sign_x40 = s1_x40;
    end else begin
        diff_x40 = e2_x40 - e1_x40;
        mx_x40   = m2_x40;
        my_x40   = m1_x40>>diff_x40;
        exy_x40  = e2_x40 + 1'b1;
        sign_x40 = s2_x40;
    end
    
//If signes of two number are different subtracting else adding    
    sr_x40 = s1_x40^s2_x40;
    if(sr_x40 == 0) begin
        mx_x40y  = mx_x40 + my_x40;
        sign_x40 = s1_x40;
    end else begin
        mx_x40y  = mx_x40 - my_x40;
    end
    mx_x40y2 = mx_x40y;
   
//Calculating sign and exponent of the sum
    if(s1_x40 == 0 && s2_x40 == 0)
        sign_x40 = 1'b0;
    else if (s1_x40 == 1 && s2_x40 == 1)
        sign_x40 = 1'b1;
    else if (s1_x40 == 0 && s2_x40 == 1)begin
        if(e1_x40 < e2_x40 || ((e1_x40 == e2_x40) && (m1_x40 < m2_x40)))
            sign_x40 = 1'b1;
        else
            sign_x40 = 1'b0;
    end
    else begin
        if(e1_x40 < e2_x40 || ((e1_x40 == e2_x40) && (m1_x40 < m2_x40)))
            sign_x40 = 1'b0;
        else
            sign_x40 = 1'b1;
    end
    
//Normalizing by shifting till we find first 1
      repeat(24)
      if (mx_x40y[24] == 0) begin
           mx_x40y = mx_x40y << 1;
           exy_x40 = exy_x40 - 1;
       end
       if (mx_x40y[23:0] == 24'b0000000000000000000000000) begin
           out_x40 = 32'b00000000000000000000000000000000;
       end else begin
           out_x40 = {sign_x40,exy_x40,mx_x40y[23:1]};
       end
end
endmodule

