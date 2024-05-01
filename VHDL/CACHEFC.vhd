library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CFC is
    port(
        I1, I2, I3: in std_ulogic_vector(31 downto 0);  -- Input signals for address, write data, and data from memory (in case of cache miss)
        C1, C2, C3, C4: in std_ulogic;                -- Input signals for memory write, memory read, L2 ready, and cache hit
        O1, O2: out std_ulogic_vector(31 downto 0);    -- Output signals for memory address and data to be written to cache
        O3, O4: out std_ulogic                         -- Output signals for memory write and memory read
    );
end CFC;

architecture CFC1 of CFC is
    signal D1, D2, D3, D8, D9: std_ulogic_vector(31 downto 0) := (others => '0');  -- Signals for address, write data, data from memory, and output memory address and data
    signal D4, D5, D6, D7, D10, D11: std_ulogic := '0';                              -- Signals for control flags
begin
    D1 <= I1;  -- Assign input I1 to D1 (address)
    D2 <= I2;  -- Assign input I2 to D2 (write data)
    D3 <= I3;  -- Assign input I3 to D3 (data from memory)

    D4 <= C1;  -- Assign input C1 to D4 (memory write)
    D5 <= C2;  -- Assign input C2 to D5 (memory read)
    D6 <= C3;  -- Assign input C3 to D6 (L2 ready)
    D7 <= C4;  -- Assign input C4 to D7 (cache hit)

    feedbackcontrol: process(D1, D2, D3, D4, D5, D6, D7)
    begin
        D8 <= D1;  -- Assign D1 to D8 (output memory address)
        if (D4 = '0' and D5 = '1' and D6 = '1' and D7 = '0') then  -- If memory read operation and cache miss
            D9 <= D3;  -- Assign D3 to D9 (data from memory)
            D10 <= '1';  -- Set memory write flag to '1'
            D11 <= '0';  -- Set memory read flag to '0'
        else
            D9 <= D2;  -- Assign D2 to D9 (write data)
            D10 <= D4;  -- Assign D4 to D10 (memory write flag)
            D11 <= D5;  -- Assign D5 to D11 (memory read flag)
        end if;
    end process feedbackcontrol;

    O1 <= D8;  -- Output memory address
    O2 <= D9;  -- Output data to be written to cache
    O3 <= D10;  -- Output memory write flag
    O4 <= D11;  -- Output memory read flag
end CFC1;
