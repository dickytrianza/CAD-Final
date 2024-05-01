library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SG is
    port (
        CLK: out std_ulogic  -- Output clock signal
    );
end SG;

architecture SG1 of SG is
    signal DCLK: std_ulogic := '0';  -- Internal signal to generate clock pulses
begin
    -- Process to generate clock pulses
    clkGEN: process
    begin
        DCLK <= '0';  -- Set DCLK low
        wait for 50 ns;  -- Wait for 50 ns
        DCLK <= '1';  -- Set DCLK high
        wait for 50 ns;  -- Wait for another 50 ns
    end process;

    -- Assign the generated clock signal to the output port CLK
    CLK <= DCLK;
end SG1;
