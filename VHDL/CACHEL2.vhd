-- Description: This code represents a Level 2 cache with memory read and write functionality.

-- Library and package imports
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration for CACHEL2 module
entity CACHEL2 is
    generic (
        N: integer  -- Parameter specifying the number of memory blocks
    );
    port (
        I1, I2: in std_ulogic_vector(31 downto 0);  -- Input ports for memory address and write data
        O1: out std_ulogic_vector(31 downto 0);     -- Output port for data read from cache
        O2: out std_ulogic;                         -- Output port for cache hit signal
        C1, C2: in std_ulogic                       -- Input ports for memory write and read signals
    );
end CACHEL2;

-- Architecture for CACHEL2 module
architecture CACHEL21 of CACHEL2 is
    -- Type declaration for memory array
    type MEMORY is array (0 to (N-1)) of std_ulogic_vector(31 downto 0);  -- N*4 byte memory
    -- Signal declaration for memory
    signal M1: MEMORY := (
        "00000000000000000000000000000000",  -- Initial memory content
        "00000000000000000000000000000100",  -- Initial memory content
        others => (others => '0')            -- Default memory content
    );
    -- Signals for address, write data, and cache output data
    signal D1, D2, R1: std_ulogic_vector(31 downto 0) := (others => '0');
    -- Signals for memory write and read signals, and cache hit signal
    signal D3, D4, R2: std_ulogic := '0';
begin
    -- Assign memory address, write data, and memory write/read signals with transport delay
    D1 <= transport I1 after 201 ns;  -- Memory address
    D2 <= transport I2 after 201 ns;  -- Write data
    D3 <= transport C1 after 201 ns;  -- Memory write signal
    D4 <= transport C2 after 201 ns;  -- Memory read signal

    -- Read data from memory if memory read signal is active and address is within memory range
    R1 <= M1(to_integer(unsigned(D1))) when (D3 = '0' and D4 = '1' and to_integer(unsigned(D1)) < (N-1));

    -- Write data to memory if memory write signal is active and address is within memory range
    M1(to_integer(unsigned(D1))) <= D2 when (D3 = '1' and D4 = '0' and to_integer(unsigned(D1)) < (N-1));

    -- Process for generating cache hit signal
    readypulse: process(D1, D2, D3, D4)
        variable FLAG: std_ulogic := '0';  -- Variable for cache hit flag
    begin
        FLAG := '0';

        -- Set cache hit flag if memory read/write operation is within memory range
        if ((D3 = '0' and D4 = '1' and to_integer(unsigned(D1)) < (N-1)) or 
            (D3 = '1' and D4 = '0' and to_integer(unsigned(D1)) < (N-1))) then
            FLAG := '1';
        end if;

        -- Assign cache hit flag to output port
        R2 <= FLAG;
    end process readypulse;
    
    -- Assign output ports
    O1 <= R1;  -- Data read from cache
    O2 <= R2;  -- Cache hit signal
end CACHEL21;
