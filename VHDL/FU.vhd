library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FU is
    port (
        I1, I2, I3, I4: in std_ulogic_vector(4 downto 0);  -- Input data signals
        C1, C2: in std_ulogic;                              -- Control signals
        O1, O2: out std_ulogic_vector(1 downto 0)           -- Output data signals
    );
end FU;

architecture FU1 of FU is
    -- Signals to hold input data and control signals
    signal D1, D2, D3, D4: std_ulogic_vector(4 downto 0) := (others => '0');
    signal D5, D6: std_ulogic := '0';
    -- Signals to hold output data
    signal R1, R2: std_ulogic_vector(1 downto 0) := (others => '0');
begin
    -- Assign input data and control signals to internal signals
    D1 <= I1;  -- Write Address 1
    D2 <= I2;  -- Write Address
    D3 <= I3;  -- Rs (s2)
    D4 <= I4;  -- Rt (s3, R)
    D5 <= C1;  -- RegWrite2 (ex/mem)
    D6 <= C2;  -- RegWrite (mem/wb)

    -- Forwarding logic for source operand 1
    R1 <= "10" when D3 = D1 and D5 = '1' else  -- Forward from execution/memory stage (ex/mem)
          "01" when D3 = D2 and D6 = '1' else  -- Forward from memory/write-back stage (mem/wb)
          "00";                               -- No forwarding

    -- Forwarding logic for source operand 2
    R2 <= "10" when D4 = D1 and D5 = '1' else  -- Forward from execution/memory stage (ex/mem)
          "11" when D4 = D2 and D6 = '1' else  -- Forward from memory/write-back stage (mem/wb)
          "00";                               -- No forwarding

    -- Assign output data signals
    O1 <= R1;  -- Output for mux above
    O2 <= R2;  -- Output for mux below
end FU1;
