module instruction_memory(
    input  logic [31:0] pc, 
    output logic [31:0] instruction
); 

//Memory block 
logic [31:0] instruction_block [255:0]; 
logic [7:0] index; 

assign index = pc[9:2]; 

always_comb begin
    instruction = instruction_block[index]; 
end


endmodule