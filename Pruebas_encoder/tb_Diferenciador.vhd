LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_Diferenciador IS
END ENTITY;

ARCHITECTURE sim OF tb_Diferenciador IS

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL Posicion_Continua : STD_LOGIC_VECTOR(31 DOWNTO 0)
        := (OTHERS => '0');

    SIGNAL DeltaP : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    DUT : ENTITY work.Diferenciador
    PORT MAP(
        clk               => clk,
        rst               => rst,
        Posicion_Continua => Posicion_Continua,
        DeltaP            => DeltaP
    );

    clk <= NOT clk AFTER 10 ns;

    PROCESS
    BEGIN

        WAIT FOR 100 ns;
        rst <= '0';

        Posicion_Continua <= X"00000000";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"0000000A";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"00000014";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"0000001E";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"00000028";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"00000023";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"0000001E";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"00000019";

        WAIT FOR 45 ms;
        Posicion_Continua <= X"00000014";

        WAIT;

    END PROCESS;

END ARCHITECTURE;