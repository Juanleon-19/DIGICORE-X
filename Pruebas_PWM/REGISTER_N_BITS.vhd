LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY REGISTER_N_BITS IS

    GENERIC(
        MAX_WIDTH : INTEGER := 8
    );

    PORT(
        D   : IN  STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
        ENA : IN  STD_LOGIC;
        RST : IN  STD_LOGIC;
        CLK : IN  STD_LOGIC;
        Q   : OUT STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE rtl OF REGISTER_N_BITS IS

BEGIN

    GEN_BITS : FOR i IN 0 TO MAX_WIDTH-1 GENERATE

        FF : ENTITY work.Flip_Flop_D_RE
        PORT MAP(
            D   => D(i),
            ENA => ENA,
            RST => RST,
            CLK => CLK,
            Q   => Q(i)
        );

    END GENERATE;

END rtl;