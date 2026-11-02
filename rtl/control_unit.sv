module contrul_unit (
    input  logic [31:0] instruction, 
    output logic [3:0]  alu_control, 
    output logic [2:0]  imm_format,
    output logic [2:0]  branch_logic,
    output logic [1:0]  wb_select,
    output logic        reg_write_en, 
    output logic        alu_src,  
    output logic        mem_read, 
    output logic        mem_write, 
    output logic        branch, 
    output logic        jump
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

/*
000 - R Type
001 - I Type 
010 - S Type 
011 - B Type
100 - U Type 
101 - J Type 
*/

/*
Branch Logic 
000 - BEQ (equal)
001 - BNE (not equal)
010 - BLT (less than)
011 - BGE (greater than or equal to)
100 - BLTU (less than unsigned)
101 - BGEU (greater than or equal to unsigned)
*/

/*
Write back select
00 - ALU result
01 - Data memory output
10 - PC + 4
11 - Immediate

*/

logic [6:0] opcode; 
logic [2:0] funct3; 
logic [6:0] funct7; 

assign opcode = instruction[6:0]; 
assign funct3 = instruction[14:12]; 
assign funct7 = instruction[31:25]; 

localparam logic [6:0] R_TYPE = 7'b0110011;
localparam logic [6:0] I_TYPE = 7'b0010011; 
localparam logic [6:0] LOAD = 7'b0000011; 
localparam logic [6:0] STORE = 7'b0100011; 
localparam logic [6:0] BRANCH = 7'b1100011; 
localparam logic [6:0] JAL = 7'b1101111; 
localparam logic [6:0] LUI = 7'b0110111; 
localparam logic [6:0] AUIPC = 7'b0010111; 


always_comb begin
    alu_control = 4'b0000; 
    imm_format = 3'b000;
    branch_logic = 3'b000; 
    reg_write_en = 1'b0;
    alu_src = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    wb_select = 2'b0;
    branch = 1'b0;
    jump = 1'b0;
    

    /*
    alu_control = Tells ALU which mathematical or logical operation to perform.
    imm_format = Tells immediate_gen module which instruction format to extract the immediate from.
    reg_write_en = Determines whether the register file should write data into a destination register (rd).
    alu_src = Determines where the ALU gets its second input (operand_two).
    mem_read = Determines whether the processor reads data from data memory.
    mem_write = Determines whether the processor writes data into data memory.
    wb_select = Determines which data source is sent to the register file's write-data input (ALU result, data memory output, Immedaite, or PC + 4)
    branch = Indicates whether the current instruction is a conditional branch.
    jump = Indicates whether the current instruction is an unconditional jump.
    */

    case(opcode) 
    R_TYPE: begin 
        imm_format = 3'b000; 
        reg_write_en = 1'b1; 
        alu_src = 1'b0; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b0; 
        branch = 1'b0; 
        jump = 1'b0; 

        case (funct3)
        3'b000: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0; 
            end
            else if (funct7 == 7'b0100000) begin
                alu_control = 4'b0001; 
            end
        end
        3'b001: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0101; 
            end
        end
        3'b010: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b1000; 
            end
        end
        3'b011: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b1001; 
            end
        end
        3'b100: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0100; 
            end
        end
        3'b101: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0110; 
            end
            else if (funct7 == 7'b0100000) begin
                alu_control = 4'b0111; 
            end
        end
        3'b110: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0011; 
            end
        end
        3'b111: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0010; 
            end
        end
        endcase

    end
    I_TYPE: begin
        imm_format = 3'b001; 
        reg_write_en = 1'b1; 
        alu_src = 1'b1; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b0; 
        branch = 1'b0; 
        jump = 1'b0;

        case (funct3) 
        3'b000: alu_control = 4'b0000; 
        3'b001: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0101;
            end
        end
        3'b010: alu_control = 4'b1000; 
        3'b011: alu_control = 4'b1001; 
        3'b100: alu_control = 4'b0100; 
        3'b101: begin
            if (funct7 == 7'b0) begin
                alu_control = 4'b0110; 
            end
            else if (funct7 == 7'b0100000) begin
                alu_control = 4'b0111; 
            end
        end
        3'b110: alu_control = 4'b0011; 
        3'b111: alu_control = 4'b0010; 
        endcase
        
    end
    LOAD: begin
        imm_format = 3'b001; 
        reg_write_en = 1'b1; 
        alu_src = 1'b1; 
        mem_read = 1'b1; 
        mem_write = 1'b0; 
        wb_select = 2'b01; 
        branch = 1'b0; 
        jump = 1'b0;
        alu_control = 4'b0000;
    end
    STORE: begin
        imm_format = 3'b010;
        reg_write_en = 1'b0; 
        alu_src = 1'b1; 
        mem_read = 1'b0; 
        mem_write = 1'b1; 
        wb_select = 2'b0; 
        branch = 1'b0; 
        jump = 1'b0;
        alu_control = 4'b0000;
    end
    BRANCH: begin
        imm_format = 3'b011;
        reg_write_en = 1'b0; 
        alu_src = 1'b0; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b0; 
        branch = 1'b1; 
        jump = 1'b0;
        
        case (funct3) 
        3'b000: begin
            branch_logic = 3'b000;
            alu_control = 4'b0001;
        end  
        3'b001: begin
            branch_logic = 3'b001;
            alu_control = 4'b0001;
        end
        3'b100: begin
            branch_logic = 3'b010;
            alu_control = 4'b1000;
        end 
        3'b101: begin
            branch_logic = 3'b011;
            alu_control = 4'b1000;
        end 
        3'b110: begin
            branch_logic = 3'b100;
            alu_control = 4'b1001;
        end 
        3'b111: begin
            branch_logic = 3'b101;
            alu_control = 4'b1001;
        end 
        endcase
    end
    JAL: begin
        imm_format = 3'b101;
        reg_write_en = 1'b1; 
        alu_src = 1'b0; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b10; 
        branch = 1'b0; 
        jump = 1'b1;
    end
    LUI: begin
        imm_format = 3'b100;
        reg_write_en = 1'b1; 
        alu_src = 1'b0; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b11; 
        branch = 1'b0; 
        jump = 1'b0;
    end
    AUIPC: begin
        imm_format = 3'b100;
        reg_write_en = 1'b1; 
        alu_src = 1'b1; 
        mem_read = 1'b0; 
        mem_write = 1'b0; 
        wb_select = 2'b00; 
        branch = 1'b0; 
        jump = 1'b0;
    end
    endcase
end



endmodule

