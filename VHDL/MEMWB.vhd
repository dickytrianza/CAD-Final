library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMWB is
    port (
        I1, I2: in std_ulogic_vector(31 downto 0);   -- Data inputs from the memory stage
        I3: in std_ulogic_vector(4 downto 0);        -- Input for holding destination register
        I10, I14: in std_ulogic;                     -- Control signals
        O1, O2: out std_ulogic_vector(31 downto 0);  -- Data outputs to the write-back stage
        O3: out std_ulogic_vector(4 downto 0);       -- Output for holding destination register
        O10, O14: out std_ulogic;                    -- Control signal outputs
        C1, clk: in std_ulogic                        -- Clock and control signal
    );
end MEMWB;

architecture MEMWB1 of MEMWB is
    -- Signals to hold data between clock cycles
    signal D1, D2: std_ulogic_vector(31 downto 0) := (others => '0');
    signal D3: std_ulogic_vector(4 downto 0) := (others => '0');
    -- Signals to hold control signals
    signal D10, D14, D17: std_ulogic := '0';
begin
    D17 <= C1;  -- Update control signal

    -- Process to capture input data and control signals on rising clock edge when control signal is active
    pc: process(clk)
    begin
        if (clk = '1' and clk'event and D17 = '1') then
            -- Capture inputs
            D1 <= I1;
            D2 <= I2;
            D3 <= I3;
            D10 <= I10;
            D14 <= I14;
        end if;
    end process;

    -- Assign outputs
    O1 <= D1;
    O2 <= D2;
    O3 <= D3;
    O10 <= D10;
    O14 <= D14;

end MEMWB1;
