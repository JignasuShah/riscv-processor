module alu(
    input logic [31:0] operand_one, 
    input logic [31:0] operand_two, 
    input logic [3:0] alu_control,
    output logic [31:0] result
); 

/* 
ALU_signal	Operation
0000	    ADD
0001	    SUB
0010	    AND
0011	    OR
0100	    XOR
0101	    SLL
0110	    SRL
0111	    SRA
1000	    SLT (signed comparison)
1001	    SLTU (unsigned comparison)

*/

localparam logic [3:0] ADD =  4'b0000;
localparam logic [3:0] SUB =  4'b0001; 
localparam logic [3:0] AND =  4'b0010;
localparam logic [3:0] OR  =  4'b0011;
localparam logic [3:0] XOR =  4'b0100;
localparam logic [3:0] SLL =  4'b0101;
localparam logic [3:0] SRL =  4'b0110;
localparam logic [3:0] SRA =  4'b0111;
localparam logic [3:0] SLT =  4'b1000;
localparam logic [3:0] SLTU = 4'b1001; 


logic [4:0] shift_amount; 
assign shift_amount = operand_two[4:0]; 


always_comb begin
    case(alu_control) 
        ADD: result = operand_one + operand_two; 
        SUB: result = operand_one - operand_two; 
        AND: result = operand_one & operand_two; 
        OR:  result = operand_one | operand_two; 
        XOR: result = operand_one ^ operand_two; 
        SLL: result = operand_one << shift_amount; 
        SRL: result = operand_one >> shift_amount; 
        SRA: result = $signed(operand_one) >>> shift_amount; 
        SLT: result = ($signed(operand_one) < $signed(operand_two)) ? 32'b1 : 32'b0; 
        SLTU: result = (operand_one < operand_two) ? 32'b1 : 32'b0; 
        default: result = 32'b0; 
    endcase
end

endmodule