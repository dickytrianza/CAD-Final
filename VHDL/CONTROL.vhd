-- Description: This VHDL code implements a control unit for a processor.
--              It decodes instruction codes and generates control signals
--              for various components including ALU, memory, and register file.

-- Library and package imports
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration for CONTROL module
entity CONTROL is
    port (
        I1: in std_ulogic_vector(5 downto 0);           -- Input port for instruction code
        O1, O2, O3, O4, O5, O7, O8, O9: out std_ulogic; -- Output ports for various control signals
        O6: out std_ulogic_vector(2 downto 0)            -- Output port for ALU operation code
    );
end CONTROL;

-- Architecture for CONTROL module
architecture CTRL1 of CONTROL is
    -- Signal declaration for register to store control signals
    signal R1: std_ulogic_vector(10 downto 0) := (others => '0');
    -- Signal declaration for ALU operation code
    signal R6: std_ulogic_vector(2 downto 0) := (others => '0');
    -- Signal declaration for input instruction code
    signal D1: std_ulogic_vector(5 downto 0) := (others => '0');
    -- Signals for individual control signals
    signal D4, D7, D9: std_ulogic;
begin
    D1 <= I1;  -- Assign input instruction code to signal D1

    -- Decode instruction code and generate control signals
    with D1 select
        R1 <=
            "10000000001" when "100000", -- R-type instruction (RegDst:1, Jump:0, Branch:0, MemRead:0, MemtoReg:0, ALUOp:001, MemWrite:0, ALUSrc:0, RegWrite:1)
            "00000001011" when "000001", -- I sum arithmetic instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:1, ALUOp:101, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00011001011" when "000010", -- I sum load instruction (RegDst:0, Jump:0, Branch:0, MemRead:1, MemtoReg:1, ALUOp:011, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00001001110" when "000011", -- I sum store instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:0, ALUOp:011, MemWrite:1, ALUSrc:1, RegWrite:0)
            "00000010011" when "000100", -- I and instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:1, ALUOp:000, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00000011011" when "000101", -- I or instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:1, ALUOp:001, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00000100011" when "000110", -- I shift left instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:1, ALUOp:010, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00000101011" when "000111", -- I shift right instruction (RegDst:0, Jump:0, Branch:0, MemRead:0, MemtoReg:1, ALUOp:011, MemWrite:0, ALUSrc:1, RegWrite:1)
            "00100110010" when "001000", -- Conditional branch instruction (RegDst:0, Jump:1, Branch:0, MemRead:0, MemtoReg:0, ALUOp:100, MemWrite:0, ALUSrc:0, RegWrite:0)
            "01000111010" when "010000", -- Unconditional jump instruction (RegDst:0, Jump:1, Branch:0, MemRead:0, MemtoReg:0, ALUOp:000, MemWrite:0, ALUSrc:0, RegWrite:0)
            "00000000000" when others;   -- No operation (NOP) instruction

    -- Assign individual control signals to output ports
    O1 <= R1(10);            -- RegDst
    O2 <= R1(9);             -- Jump
    O3 <= R1(8);             -- Branch
    O5 <= R1(6);             -- MemtoReg
    O8 <= R1(1);             -- ALUSrc
    O6 <= R1(5 downto 3);    -- ALUOp
    O4 <= R1(7);             -- MemRead
    O7 <= R1(2);             -- MemWrite
    O9 <= R1(0);             -- RegWrite

end CTRL1;
