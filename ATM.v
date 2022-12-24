
module ATM (
input  wire        in_card, in_Lang, in_AnotherOp ,
input  wire        rst,
input  wire        clk,
input  wire [3:0]  in_PIN,
input  wire [1:0]  in_operation,
input  wire [3:0]  depositAmount,
input  wire [3:0]  withdrawAmount,
output reg         Balance_out,
output reg         O_NotEnough
);

reg    NotEnoughBalance;

localparam  [2:0]   Card_Entry = 3'b000,
                    Language = 3'b001,
                    PIN_Entry = 3'b010,
		            Transaction = 3'b011,
		            Deposit = 3'b100,
		            Withdraw = 3'b101 ,
					Balance = 3'b110;
					 
reg    [2:0]        current_state,
                    next_state ;
		
reg    [3:0]		correct_PIN;

reg    [3:0]        User_Balance;


// state transition 		
always @(posedge clk or negedge rst)
 begin
  if(!rst)
   begin
     current_state <= Card_Entry ;
	 correct_PIN <= 1111;
	 User_Balance <=1000;
   end
  else
   begin
     current_state <= next_state ;
   end
 end
 
 
 
// next_state logic
always @(*)
 begin
  case(current_state)
  
  
  Card_Entry     : begin
			
              if(in_card)
			   next_state = Language ;
	      
              else
               next_state = Card_Entry ;			  
             end
			 
			 
  Language       : begin
              if(in_Lang)
			   next_state = PIN_Entry ;
	      
              else
               next_state = Language ;	   
            end
			
			
			
  PIN_Entry     : begin
              if(in_PIN[0] == 1'b1 && in_PIN[1] == 1'b1 && in_PIN[2] == 1'b1 && in_PIN[3] == 1'b1)
			   next_state = Transaction ;
	      
              else
               next_state = PIN_Entry ;	    
            end
			
			
			
  Transaction    : begin
              if(in_operation == 2'b 00)
			   next_state = Transaction ;
	          else if (in_operation == 2'b 01)
               next_state = Deposit ;
              else if(in_operation == 2'b 10)
               next_state = Withdraw ;	 
              else if(in_operation == 2'b 11)
               	next_state = Balance ;		  
            end
			
			
			
  Deposit   : begin
             if(in_AnotherOp == 1'b 1)
			   next_state = Transaction ;
	         else if (in_AnotherOp == 1'b 0)
               next_state = Card_Entry ;
                
            end	


			
  Withdraw   : begin
			if(User_Balance < withdrawAmount)
				NotEnoughBalance = 1'b 1;
			else
				begin
             	NotEnoughBalance = 1'b 0;
				end
		    if(NotEnoughBalance)
			   next_state = Withdraw ;
	         else if (in_AnotherOp)
               next_state = Transaction ;
             else if(!in_AnotherOp)
               next_state = Card_Entry ;	   
            end	


			
  Balance  : begin
             if (in_AnotherOp)
               next_state = Transaction ;
			   
			 else if (!in_AnotherOp)
			   next_state = Card_Entry;
            end	
			
			
  default :   next_state = Card_Entry ;		 
  
  endcase
end	


// next_state logic
always @(*)
 begin
  case(current_state)
  
  Card_Entry: begin
              Balance_out   =  1'b0 ;
              O_NotEnough =	1'b0;		  
             end
			 
  Language : begin
              Balance_out   =  1'b0 ;
			  O_NotEnough =	1'b0;
             end	
			 
  PIN_Entry: begin
              Balance_out   =  1'b0 ;
              O_NotEnough =	1'b0;		  
             end
			 
  Transaction: begin
              Balance_out   =  1'b0 ;	 
              O_NotEnough =	1'b0;			  
             end
			 
  Deposit  : begin
              Balance_out   =  1'b1 ;
              O_NotEnough =	1'b0;			  
             end	
			 
  Balance  : begin
              Balance_out   =  1'b1 ;
              O_NotEnough =	1'b0;			  
             end	
			 
  Withdraw : begin
  
              if(NotEnoughBalance)
			   begin
			     Balance_out= 1'b0;
				 O_NotEnough =	1'b1;
			   end
			   
			  else
               begin			  
                 Balance_out   =  1'b1 ;
                 O_NotEnough =	1'b0;
               end				 
             end	
			 
  default  : begin
              Balance_out   =  1'b0 ;
			  O_NotEnough =	1'b0;
             end			  
  endcase
 end	
    
	

    // psl assert always((current_state == Card_Entry && in_card) -> next(next_state == Language)) @(posedge clk);
    // psl assert always((rst == 1'b0) -> next(current_state == Card_Entry)) @(posedge clk);
    // psl assert never(Balance_out && O_NotEnough)  ;
	
		
endmodule		

