library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library STD;
use STD.textio.all;

entity IM is
    generic (
        N: integer  -- Generic parameter defining the size of the memory (number of instructions)
    );
    port (
        I1: in std_ulogic_vector(31 downto 0);    -- Input for fetching instruction at a specific address
        O1: out std_ulogic_vector(31 downto 0)     -- Output instruction fetched
    );
end IM;

architecture IM1 of IM is
    -- Type definition for memory
    type MEMORY is array (0 to (N-1)) of std_ulogic_vector(31 downto 0);  -- N*4 byte memory
    -- Signal declaration for memory
    signal M1: MEMORY := (others => (others => '0'));  -- Initialize memory with zeros
    signal D1: std_ulogic_vector(29 downto 0) := (others => '0');  -- Signal to hold PC/4
    signal R1: std_ulogic_vector(31 downto 0) := (others => '0');  -- Signal to hold fetched instruction
begin
    -- Extract PC/4 from input
    D1 <= I1(31 downto 2);

    -- Process to initialize memory from a text file
    initmem: process
        file fp: text;
        variable ln: line;
        variable instruction: string(1 to 32);
        variable i, j: integer := 0;
        variable ch: character := '0';
    begin
        file_open(fp, "instruction.txt", READ_MODE);  -- Open instruction file
        while not endfile(fp) loop
            readline(fp, ln);  -- Read a line from the file
            read(ln, instruction);  -- Read the instruction from the line
            for j in 1 to 32 loop
                ch := instruction(j);
                if(ch = '0') then
                    M1(i)(32-j) <= '0';  -- Store the instruction in memory
                else
                    M1(i)(32-j) <= '1';
                end if;
            end loop;
            i := i+1;
        end loop;
        file_close(fp);  -- Close the file
        wait;
    end process;

    -- Fetch instruction from memory based on PC/4
    R1 <= M1(to_integer(unsigned(D1))) when to_integer(unsigned(D1)) < (N-1) else
          std_ulogic_vector(to_signed(-1, 32)) when to_integer(unsigned(D1)) > (N-1);

    -- Output fetched instruction
    O1 <= R1;
end IM1;
