library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX is
    generic (N: integer);
    port (
        I1: in std_ulogic_vector((N-1) downto 0);  -- Input vector 1
        I2: in std_ulogic_vector((N-1) downto 0);  -- Input vector 2
        C1: in std_ulogic;                         -- Control signal
        O1: out std_ulogic_vector((N-1) downto 0)  -- Output vector
    );
end MUX;

architecture MUX1 of MUX is
    -- Signals to hold input vectors and control signal
    signal D1: std_ulogic_vector((N-1) downto 0) := (others => '0');
    signal D2: std_ulogic_vector((N-1) downto 0) := (others => '0');
    signal D3: std_ulogic := '0';
    -- Signal to hold selected output vector
    signal R1: std_ulogic_vector((N-1) downto 0) := (others => '0');
begin
    -- Assign input vectors and control signal to internal signals
    D1 <= I1;
    D2 <= I2;
    D3 <= C1;

    -- Select output based on control signal
    R1 <= D1 when D3 = '0' else  -- Select input vector 1 when control signal is 0
          D2;                    -- Select input vector 2 when control signal is 1

    -- Assign selected output vector to output port
    O1 <= R1;
end MUX1;
