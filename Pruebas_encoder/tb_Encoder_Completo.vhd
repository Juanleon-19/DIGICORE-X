LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_Encoder_Completo IS
END ENTITY;

ARCHITECTURE sim OF tb_Encoder_Completo IS

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL ENC_A : STD_LOGIC := '0';
    SIGNAL ENC_B : STD_LOGIC := '0';

    SIGNAL Posicion_Continua : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RPM               : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Tick_40ms         : STD_LOGIC;

BEGIN

    DUT : ENTITY work.Encoder_Completo
    PORT MAP(
        clk               => clk,
        rst               => rst,
        ENC_A             => ENC_A,
        ENC_B             => ENC_B,
        Posicion_Continua => Posicion_Continua,
        RPM               => RPM,
        Tick_40ms         => Tick_40ms
    );

    clk <= NOT clk AFTER 10 ns;

    PROCESS
    BEGIN

        rst <= '1';

        WAIT FOR 200 ns;

        rst <= '0';

        WAIT;

    END PROCESS;

    PROCESS
    BEGIN

        WAIT UNTIL rst='0';

        LOOP

            ENC_A <= '0'; ENC_B <= '0';
            WAIT FOR 500 ns;

            ENC_A <= '0'; ENC_B <= '1';
            WAIT FOR 500 ns;

            ENC_A <= '1'; ENC_B <= '1';
            WAIT FOR 500 ns;

            ENC_A <= '1'; ENC_B <= '0';
            WAIT FOR 500 ns;

        END LOOP;

    END PROCESS;

END ARCHITECTURE;