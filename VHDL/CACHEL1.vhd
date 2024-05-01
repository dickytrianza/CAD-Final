library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CACHEL1 is
    port(
        I1, I2: in std_ulogic_vector(31 downto 0);  -- Input signals for memory address and write data
        O1, O2: out std_ulogic_vector(31 downto 0);  -- Output signals for memory address and data to be written to memory
        O3, O4: out std_ulogic;                     -- Output signals for cache hit and cache ready
        C1, C2: in std_ulogic                       -- Input signals for memory write and memory read
    );
end CACHEL1;

architecture CACHEL11 of CACHEL1 is
    type MEMORY is array (0 to 31) of std_ulogic_vector(59 downto 0);  -- Type for cache memory
    signal M1: MEMORY := (others => (others => '0'));  -- Cache memory
    signal D1, D2, R2, R3: std_ulogic_vector(31 downto 0) := (others => '0');  -- Signals for address, write data, and output data
    signal D3, D4, HIT, READY: std_ulogic := '0';  -- Signals for control flags
begin
    D1 <= transport I1 after 13 ns;  -- Assign input I1 to D1 (memory address) with a transport delay of 13 ns
    D2 <= transport I2 after 13 ns;  -- Assign input I2 to D2 (write data) with a transport delay of 13 ns
    D3 <= transport C1 after 13 ns;  -- Assign input C1 to D3 (memory write) with a transport delay of 13 ns
    D4 <= transport C2 after 13 ns;  -- Assign input C2 to D4 (memory read) with a transport delay of 13 ns

    Control: process(D1, D2, D3, D4)
        variable MEMDATA: std_ulogic_vector(59 downto 0) := (others => '0');  -- Variable to hold data from cache memory
        variable VALIDFLAG, TAGFLAG, HITFLAG, READYFLAG: std_ulogic := '0';  -- Variables for control flags
    begin
        if (to_integer(unsigned(D1(4 downto 0))) < 32) then  -- Check if memory address is within cache size
            MEMDATA := M1(to_integer(unsigned(D1(4 downto 0))));  -- Read data from cache memory
            VALIDFLAG := MEMDATA(59);  -- Get valid flag from cache memory
        end if;

        if (D1(31 downto 5) = MEMDATA(58 downto 32)) then  -- Check if tag matches
            TAGFLAG := '1';
        else
            TAGFLAG := '0';
        end if;

        if (D3 = '0' and D4 = '0' and MEMDATA = "000000000000000000000000000000000000000000000000000000000000") then  -- Check for cache miss
            HITFLAG := '1';
        else
            HITFLAG := VALIDFLAG and TAGFLAG;  -- Check for cache hit
        end if;

        READYFLAG := '0';

        if (D3 = '0' and D4 = '1') then  -- Memory read operation
            if (HITFLAG = '1') then  -- Cache hit
                R2 <= MEMDATA(31 downto 0);  -- Output data from cache
                READYFLAG := '1';
            else
                R2 <= D1;  -- Output memory address to read from memory
                READYFLAG := '1';
            end if;
        elsif (D3 = '1' and D4 = '0') then  -- Memory write operation
            if (VALIDFLAG = '0') then  -- Write data to cache (cache miss)
                M1(to_integer(unsigned(D1(4 downto 0)))) <= '1' & D1(31 downto 5) & D2;  -- Write data to cache memory
                HITFLAG := '1';
                READYFLAG := '1';
            elsif (VALIDFLAG = '1') then  -- Update data in cache (cache hit)
                if (HITFLAG = '1') then
                    M1(to_integer(unsigned(D1(4 downto 0)))) <= '1' & D1(31 downto 5) & D2;  -- Update data in cache memory
                    READYFLAG := '1';
                else
                    R3 <= MEMDATA(31 downto 0);  -- Data to be written back to memory
                    R2 <= MEMDATA(58 downto 32) & D1(4 downto 0);  -- Memory address for write-back
                    M1(to_integer(unsigned(D1(4 downto 0)))) <= '1' & D1(31 downto 5) & D2;  -- Update data in cache memory
                    READYFLAG := '1';
                end if;
            end if;
        end if;

        HIT <= HITFLAG;  -- Output cache hit signal
        READY <= READYFLAG;  -- Output cache ready signal
    end process Control;

    O1 <= R2;  -- Output memory address or data read from cache
    O2 <= R3;  -- Output data to be written back to memory
    O3 <= HIT;  -- Output cache hit signal
    O4 <= READY;  -- Output cache ready signal

end CACHEL11;
