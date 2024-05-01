
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDER is
    port(
        I1, I2: in std_ulogic_vector(31 downto 0);   -- Inputs I1 and I2, each 32 bits wide
        O1: out std_ulogic_vector(31 downto 0)       -- Output O1, also 32 bits wide
    );
end ADDER;

architecture ADD1 of ADDER is
    signal D1, D2, R1: signed(31 downto 0) := (others => '0');  -- Signals for holding signed input and result, initialized to zero
begin
    D1 <= signed(I1);    -- Convert input I1 to signed and assign to D1
    D2 <= signed(I2);    -- Convert input I2 to signed and assign to D2
    R1 <= D1 + D2;        -- Add D1 and D2, store result in R1
    O1 <= std_ulogic_vector(R1);  -- Convert result R1 to std_ulogic_vector and assign to output O1
end ADD1;
