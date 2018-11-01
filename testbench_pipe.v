module testbench();
reg [31:0] a_x40,b_x40, out_x40;
reg clk_x40;

initial clk_x40 = 1'b0;
always #5 clk_x40 = ~clk_x40;

initial
 begin
 $shm_open ( "waves_unpipelined.shm" ) ;
 $shm_probe ( "AS" ) ;
 end

reg [31:0]  exp_o1_x40, exp_o2_x40, exp_o3_x40, exp_o4_x40, exp_o5_x40, exp_o6_x40, exp_o7_x40, exp_o8_x40;


fpadd_pipe f1(a_x40,b_x40, clk_x40, out_x40);
//e1,e2,exy,s1,s2,sr,sign,m1,m2,mx,my,mxy,mxy2);

initial begin

    exp_o1_x40 = 32'b 01000011100001011000000000000000;
    exp_o2_x40 = 32'b 01000001001000000000000000000000;
    exp_o3_x40 = 32'b 01000010000010000000000000000000;
    exp_o4_x40 = 32'b 11000011101011101000000000000000;
    exp_o5_x40 = 32'b 00000000000000000000000000000000;
    exp_o6_x40 = 32'b 11000010111010100000000000000000;
    exp_o7_x40 = 32'b 11000001001001000000000000000000;
    exp_o8_x40 = 32'b 01000011010100100000000000000000;
    $display ("######### TESTBENCH ##########");
    $display ("Case 1 : 98 + 169");
    
    a_x40 = 32'b01000010110001000000000000000000;
    b_x40 = 32'b01000011001010010000000000000000;
    #50
    if (exp_o1_x40 == out_x40) begin
        $display ("A : 98, B : 169 ,Sum is Correct");   
    end else begin    
        $display ("A : 98, B : 169, Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o1_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 1 end-----");
    
    #10
    //99+ (-89)
    a_x40 = 32'b 01000010110001100000000000000000;
    b_x40 = 32'b 11000010101100100000000000000000;
    
    #50
    $display ("Case 2 : 99 + (-89)");
    if (exp_o2_x40 == out_x40) begin
         $display ("A : 99, B : (-89), Sum is Correct");   
    end else begin    
         $display ("A : 99, B : (-89), Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o2_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 2 end-----");
    
    #10
    //(-45) + 79
    a_x40 = 32'b 11000010001101000000000000000000;
    b_x40 = 32'b 01000010100111100000000000000000;
    
    #50
    $display ("Case 3 : (-45) + 79");
    if (exp_o3_x40 == out_x40) begin
        $display ("A : (-45), B : 79, Sum is Correct");   
    end else begin    
        $display ("A : (-45), B : 79, Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o3_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 3 end-----");
    
    #10
    //(-283) +(-66)
    a_x40 = 32'b 11000011100011011000000000000000;
    b_x40 = 32'b 11000010100001000000000000000000;
    
    #50
    $display ("Case 4 : (-283) + (-66)");
    if (exp_o4_x40 == out_x40) begin
        $display ("A : (-283), B : (-66), Sum is Correct");   
    end else begin    
        $display ("A : (-283), B : (-66), Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o4_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 4 end-----");
    
    #10
    //0+0
    a_x40 = 32'b 00000000000000000000000000000000;
    b_x40 = 32'b 00000000000000000000000000000000;
    
    #50
    $display ("Case 5 : 0 + 0");
    if (exp_o5_x40 == out_x40) begin
        $display ("A : 0, B : 0 , Sum is Correct");   
    end else begin    
        $display ("A : 0, B : 0 , Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o5_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 5 end-----");
    
    #10
    //0+(-117)
    a_x40 = 32'b 00000000000000000000000000000000;
    b_x40 = 32'b 11000010111010100000000000000000;
    
    #50
    $display ("Case 6 : 0 + (-117)");
    if (exp_o6_x40 == out_x40) begin
        $display ("A : 0, B : (-117), Sum is Correct");   
    end else begin    
        $display ("A : 0, B : (-117), Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o6_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 6 end-----");
    
    #10
    //(-110.125) + 99.875
    a_x40 = 32'b 11000010110111000100000000000000;
    b_x40 = 32'b 01000010110001111100000000000000;
    
    #50
    $display ("Case 7 : (-110.125) + 99.875)");
    if (exp_o7_x40 == out_x40) begin
        $display ("A : (-110.125), B : 99.875, Sum is Correct");   
    end else begin    
        $display ("A : (-110.125), B : 99.875, Sum is Not Correct");  
    end
    $display ("Expected   Sum : %b ", exp_o7_x40);   
    $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 7 end-----");
    
    #10
    //110.875+99.125
    a_x40 = 32'b 01000010110111011100000000000000;
    b_x40 = 32'b 01000010110001100100000000000000;
    
    #50
    $display ("Case 8 : 110.875 + 99.125)");
    if (exp_o8_x40 == out_x40) begin
        $display ("A : 110.875, B : 99.125, Sum is Correct");   
    end else begin    
        $display ("A : 110.875, B : 99.125, Sum is Not Correct");  
    end
        $display ("Expected   Sum : %b ", exp_o8_x40);   
        $display ("Calculated Sum : %b ", out_x40);   
//    $display ("-----Case 8 end-----");
       
    $display ("######### END OF TESTBENCH ##########");
    #100 $finish();
end

endmodule



