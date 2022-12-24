module tb_ATM ;
  

// all design inputs are defined in testbench as reg to be used inside initial block 
// all design outputs are defined in testbench as wire   
  reg        Tcard;
  reg        TLang;
  reg        TAnotherOp ;
  reg        Trst;
  reg        clk_tb;
  reg [3:0]  TPIN;
  reg [1:0]  Toperation;
  reg [3:0]  TdepositAmount;
  reg [3:0]  TwithdrawAmount;
  wire       TBalance_out;
  wire 	     NotEnough;
  integer j;
  
  
//initial block
initial 
  begin

  //initial values (Directed testbench)

 // Correct directed flow
  clk_tb = 1'b0 ;
 #10 Trst = 1'b0 ;
 #10 Trst = 1'b1 ;
 #10 Tcard = 1'b1 ;
 #10 TLang = 1'b1 ;
 #10 TPIN = 4'b1111 ;
 #10 Toperation = 2'b10 ;
     TwithdrawAmount = 4'b0100 ;
 #10 TAnotherOp = 1'b1 ;
 #10 Toperation = 2'b00 ; 
 #10 Toperation = 2'b01 ;
     TdepositAmount = 4'b0100 ;
 #10 TAnotherOp = 1'b1 ;
 #10 Toperation = 2'b11 ;
 #10 TAnotherOp = 1'b0 ;

// Test Cases Flow
 #10 Tcard = 1'b0;
 #10 Tcard = 1'b1;
 #10 TLang = 1'b0;
 #10 TLang = 1'b1;
 #10 TPIN = 4'b0101;
 #10 TPIN = 4'b1111;
 #10 Toperation = 2'b00;
 #10 TAnotherOp = 1'b0;
 #10 Toperation = 2'b10;
     TwithdrawAmount = 4'b1111;
 #10 TwithdrawAmount = 4'b0100;
 #10 TAnotherOp = 1'b0;
 #10 Toperation = 2'b01;
     TdepositAmount = 4'b0100;
 #10 TAnotherOp = 1'b0;
 #40 Trst = 1'b0;



     
	 //randomization
     #10
     for( j=0; j < 30; j=j+1)
	 begin 
	   @(posedge clk_tb)	
	     Trst= $random;
		 Tcard= $random;
		 TLang= $random;
		 TPIN= $random;
		 Toperation= $random;
	     TwithdrawAmount= $random;
		 TAnotherOp= $random;
	     TdepositAmount= $random % 7; 
	 end
    
    
    #300
    $finish ;
    
  end
  
// Clock Generator  
  always #5 clk_tb = !clk_tb ;
  
// instaniate design instance 
ATM atm1 (
        .in_card(Tcard), 
        .in_Lang(TLang), 
        .in_AnotherOp(TAnotherOp), 
        .rst(Trst), 
        .clk(clk_tb), 
        .in_PIN(TPIN), 
        .in_operation(Toperation), 
        .depositAmount(TdepositAmount), 
        .withdrawAmount(TwithdrawAmount), 
        .Balance_out(TBalance_out),
	.O_NotEnough(NotEnough)
    );
	

  
  endmodule
  
