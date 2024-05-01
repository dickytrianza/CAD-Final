library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is
    port (
        I1, I2, I3: in std_ulogic_vector(4 downto 0);  -- Read register addresses
        I4: in std_ulogic_vector(31 downto 0);         -- Data to be written to the register
        C1: in std_ulogic;                             -- Control signal for register write
        O1, O2: out std_ulogic_vector(31 downto 0)     -- Output data from the read registers
    );
end REG;

architecture REG1 of REG is
    -- Type declaration for the register file
    type REGISTERFILE is array (0 to 31) of std_ulogic_vector(31 downto 0); 
    -- Signal to hold the register file data
    signal M1: REGISTERFILE := (others => (others => '0'));
    -- Signals to hold the inputs
    signal D1, D2, D3: std_ulogic_vector(4 downto 0) := (others => '0');
    signal D4: std_ulogic_vector(31 downto 0) := (others => '0');
    signal D5: std_ulogic := '0';
    -- Signals to hold the output data
    signal R1, R2: std_ulogic_vector(31 downto 0) := (others => '0');
begin
    -- Assign inputs to internal signals
    D1 <= I1;  -- Read register 1
    D2 <= I2;  -- Read register 2
    D3 <= I3;  -- Write register
    D4 <= I4;  -- Write data
    D5 <= C1;  -- Control signal for register write

    -- Read from the register file based on the read register addresses
    R1 <= M1(to_integer(unsigned(D1)));
    R2 <= M1(to_integer(unsigned(D2)));

    -- Write to the register file if the control signal for register write is active
    M1(to_integer(unsigned(D3))) <= D4 when (D5 = '1' and D4 /= std_ulogic_vector(to_signed(-1, 32)));

    -- Output the read data from the register file
    O1 <= R1;
    O2 <= R2;
end REG1;
