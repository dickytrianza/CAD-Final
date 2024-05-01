library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFID is
    port (
        I1, I2: in std_ulogic_vector(31 downto 0);   -- Inputs from the instruction fetch stage
        O1, O2: out std_ulogic_vector(31 downto 0);  -- Outputs to the instruction decode stage
        C1, clk: in std_ulogic                        -- Clock and control signal
    );
end IFID;

architecture IFID1 of IFID is
    -- Signals to hold data between clock cycles
    signal D1, D2: std_ulogic_vector(31 downto 0) := (others => '0');
    signal D3: std_ulogic := '0';  -- Signal to enable the pipeline register
begin
    D3 <= C1;  -- Update control signal (IFIDEnable)

    -- Process to capture input data on rising clock edge when control signal is active
    pc: process(clk, D3)
    begin
        if (clk = '1' and clk'event and D3 = '1') then
            -- Capture inputs
            D1 <= I1;
            D2 <= I2;
        end if;
    end process;

    -- Assign outputs
    O1 <= D1;
    O2 <= D2;
end IFID1;
