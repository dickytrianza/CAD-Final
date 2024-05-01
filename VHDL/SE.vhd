library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE is
    port (
        I1: in std_ulogic_vector(15 downto 0);   -- Input vector of 16 bits
        O1: out std_ulogic_vector(31 downto 0)   -- Output vector of 32 bits
    );
end SE;

architecture SE1 of SE is
    -- Signal to hold the extended input
    signal D1: signed(31 downto 0) := (others => '0');
begin  
    -- Perform sign extension by resizing the input to 32 bits
    D1 <= resize(signed(I1), 32);
    -- Convert the extended signed value to an unsigned vector and assign it to the output
    O1 <= std_ulogic_vector(D1);
end SE1;
