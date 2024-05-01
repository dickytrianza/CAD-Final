--***************************************
--*   ALU                               *
--*                                     *
--*   ALU operations (2^3 = 8):         *
--*   . 000 => sum                      *
--*   . 001 => subtract                 *
--*   . 010 => and                      *
--*   . 011 => or                       *
--*   . 100 => nor                      *
--*   . 101 => logical left shift       *
--*   . 110 => logical right shift      *
--*   . 111 => *2^16                    *
--*                                     *
--*   Inputs note:                      *
--*   .I1 is the input from registers   *
--*   .I2 is the input from mux         *
--*                                     *
--*   FlagZ note:                       *
--*   .O2 = 1 if inputs are equal       *
--*   .O2 = 0 if inputs are not equal   *
--*                                     *
--*   Brnach instruction note:          *
--*   if R1 = D1-D2 > 0 => D1 > D2      *
--*   if R1 = D1-D2 < 0 => D1 < D2      *
--***************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        I1, I2: in std_ulogic_vector(31 downto 0);  -- Inputs I1 and I2, each 32 bits wide
        C1: in std_ulogic_vector(2 downto 0);       -- Control input for selecting operation
        O1: out std_ulogic_vector(31 downto 0);     -- Output O1, also 32 bits wide
        O2: out std_ulogic                           -- Output O2, flag indicating equality
    );
end ALU;

architecture ALU1 of ALU is
    signal D1, D2: signed(31 downto 0) := (others => '0');     -- Signals for holding signed input
    signal D3: std_ulogic_vector(2 downto 0) := (others => '0');  -- Signal for holding control input
    signal R1: signed(31 downto 0) := (others => '0');         -- Signal for holding result
    signal FlagZ: std_ulogic := '0';                            -- Flag for indicating equality
begin
    D1 <= signed(I1);  -- Convert input I1 to signed and assign to D1
    D2 <= signed(I2);  -- Convert input I2 to signed and assign to D2
    D3 <= C1;          -- Assign control input to D3

    -- Perform operation based on control input
    with D3 select
        R1 <= D1 + D2 when "000",
              D1 - D2 when "001",
              D1 and D2 when "010",
              D1 or D2 when "011",
              not (D1 or D2) when "100",
              D1 sll to_integer(unsigned(D2)) when "101",  -- Shift left logical by amount specified in D2
              D1 srl to_integer(unsigned(D2)) when "110",  -- Shift right logical by amount specified in D2
              D2 sll 16 when "111",  -- Shift left by 16 bits
              to_signed(-1, 32) when others;  -- Default to -1 if control input does not match any operation

    -- Set FlagZ to 1 if result R1 is zero, else set to 0
    FlagZ <= '1' when R1 = to_signed(0, 32) else '0';

    O1 <= std_ulogic_vector(R1);  -- Convert result R1 to std_ulogic_vector and assign to output O1
    O2 <= FlagZ;                   -- Assign FlagZ to output O2
end ALU1;
