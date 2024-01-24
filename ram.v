`timescale 1ns/1ps

module sdram(data_out,data_in,ram_addr,write_en,clk);
input clk,write_en;
input [7:0]data_in;
input [5:0]ram_addr;
output [7:0]data_out;

reg [7:0]memory[31:0];  //memory 
reg [5:0]addr_register; //address buffer

initial
begin

end

always @(posedge clk)
begin
	if(write_en)
		memory[ram_addr] <= data_in;
	else
		addr_register <= ram_addr;
end

assign data_out = memory[ram_addr];
endmodule


//test bench

module ram_tb;
reg clk,write_en;
reg [7:0]data_in;
reg [5:0]memory;
reg [5:0] addr;

wire [7:0]data_out;
integer i,j,k;

sdram DUT(.clk(clk),.data_in(data_in),.write_en(write_en),.memory(ram_addr),.data_out(data_out));

initial
begin
	clk=0;
	
	forever 
	#10 clk=~clk;
	
end
             //test generator         
				 
initial
begin
addr=0;
#20;                        // step 1
	for(i=0;i<32;i=i+1)    //write 0
	begin
		memory[i]=8'h00;
		addr=i;
	end
	
	#20;   //step 2
	
	for(j=0;j<32;j=j+1)
	begin
		if(memory[j]== 8'h00)      //read 0
		begin
			memory[j]=8'h01;           //write 1
		   addr=j;
		end
		else
		begin
		    addr=j;
			$display("There is fault memory at memory location: %b",addr);
		end
	end
	
	#20;  //step 3
	
		for(k=0;k<32;k=k+1)
		begin
			if(memory[k]== 8'h01)      //read 1
				begin
					memory[k]=8'h00; 					//write 0
				   addr=k;
				end
			else
				begin
				addr=k;
				$display("There is fault memory at memory location: %b",addr);
				end
		end
	
	#20;  //step 4
	
	for(j=0;j<32;j=j+1)
	begin
		if(memory[j]!= 8'h00)      //read 0
		begin
		addr=j;
			  $display("there is fault memory at location: %b",addr);        
		end
	end	
	#20; //step 5            (descending order)
	for(j=31;j>=0;j=j-1)     
	begin
		if(memory[j]== 8'h00)      //read 0
		begin
			memory[j]=8'h01;           //write 1
		   addr=j;
		end
		else
		begin
			addr=j;
			$display("There is fault memory at memory location: %b",addr);
		end
	end
	
	#20; // step 6                (descending order)
	
	for(j=31;j>=0;j=j-1)
	begin
		if(memory[j]== 8'h01)      //read 1
		begin
			memory[j]=8'h00;           //write 0
		   addr=j;
		end
		else
		begin
			addr=j;
			$display("There is fault memory at memory location: %b",addr);
		end
	end
	
	#20; //step 7
	
	for(j=0;j<32;j=j+1)
	begin
		if(memory[j]!= 8'h00)      //read 0
		begin
			  addr=j;
			  $display("there is fault memory at location: %b",addr);        
		end
	end
	#20;
$finish;			
end


endmodule
