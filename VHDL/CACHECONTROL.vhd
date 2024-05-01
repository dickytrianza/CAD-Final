library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CC is
    port(
        I1, I2: in std_ulogic_vector(31 downto 0);  -- Input data or address to be read from or written to memory
        O1, O2: out std_ulogic_vector(31 downto 0);  -- Output address for memory and data to be written to memory
        O3, O4, O5, O6, O7: out std_ulogic;         -- Output signals for cache controller operations
        I3, I4, C1, C2: in std_ulogic               -- Input signals for cache controller control
    );
end CC;

architecture CC1 of CC is
    signal D1, D2, D7, D8: std_ulogic_vector(31 downto 0) := (others => '0');  -- Signals for data and address
    signal D3, D4, D5, D6, D9, D10, D11, D12, D13: std_ulogic := '0';           -- Signals for control flags
begin

    D1 <= I1;  -- Assign input I1 to D1 (data or address to be read from or written to memory)
    D2 <= I2;  -- Assign input I2 to D2 (data to be written to memory)

    control: process(D1, D2, D3, D4, D5, D6)
        variable WRITEFLAG: std_ulogic := '0';  -- Variable to indicate write operation
    begin
        D7 <= D1;  -- Assign D1 to D7 (memory address)
        D8 <= D2;  -- Assign D2 to D8 (data to be written to memory)
        WRITEFLAG := '0';  -- Initialize WRITEFLAG to '0'

        if (D3 = '1' and D4 = '1' and D5 = '0' and D6 = '1') then  -- Cache read successful
            D10 <= '0';  -- Set delayed mem write flag to '0'
            D11 <= '0';  -- Set delayed mem read flag to '0'
            D12 <= '1';  -- Set mux control signal to '1'
        elsif (D3 = '1' and D4 = '0' and D5 = '0' and D6 = '1') then  -- Cache read unsuccessful, read from memory
            D10 <= '0';  -- Set delayed mem write flag to '0'
            D11 <= '1';  -- Set delayed mem read flag to '1'
            D12 <= '0';  -- Set mux control signal to '0'
        elsif (D3 = '1' and D4 = '1' and D5 = '1' and D6 = '0') then  -- Memory write successful
            WRITEFLAG := '1';  -- Set WRITEFLAG to '1'
        elsif (D3 = '1' and D4 = '0' and D5 = '1' and D6 = '0') then  -- Memory write unsuccessful (write back)
            D10 <= '1';  -- Set delayed mem write flag to '1'
            D11 <= '0';  -- Set delayed mem read flag to '0'
            WRITEFLAG := '1';  -- Set WRITEFLAG to '1'
        end if;

        D13 <= WRITEFLAG;  -- Assign WRITEFLAG to D13 (write ready)
    end process control;

    O1 <= D7;  -- Output memory address
    O2 <= D8;  -- Output data to be written to memory
    O3 <= D9;  -- Output delayed hit signal
    O4 <= D10;  -- Output delayed mem write signal (active only if used)
    O5 <= D11;  -- Output delayed mem read signal
    O6 <= D12;  -- Output mux control signal
    O7 <= D13;  -- Output write ready signal

end CC1;
