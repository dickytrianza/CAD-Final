library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        I1: in std_ulogic_vector(31 downto 0);  -- Input for the new PC value
        O1: out std_ulogic_vector(31 downto 0); -- Output for the current PC value
        C1, clk: in std_ulogic                    -- Clock and PC enable signal
    );
end PC;

architecture PC1 of PC is
    -- Signal to hold the current PC value
    signal D1: std_ulogic_vector(31 downto 0) := (others => '0');
    signal D3: std_ulogic := '0';  -- Signal to hold PC enable

begin
    -- Assign PC enable signal to internal signal
    D3 <= C1;  -- PCEnable
    
    -- Process to update PC value on rising clock edge when PC enable is active
    pc: process(clk)
    begin
        if (clk = '1' and clk'event and D3 = '1') then
            D1 <= I1;  -- Update PC value with the new input
        end if;
    end process;

    -- Assign the current PC value to the output port
    O1 <= D1;
end PC1;
