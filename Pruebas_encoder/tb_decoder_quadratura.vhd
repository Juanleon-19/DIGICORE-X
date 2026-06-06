LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_decoder_quadratura IS
END ENTITY;

ARCHITECTURE sim OF tb_decoder_quadratura IS

    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL rst     : STD_LOGIC := '1';

    SIGNAL A_sync  : STD_LOGIC := '0';
    SIGNAL B_sync  : STD_LOGIC := '0';

    SIGNAL Enable  : STD_LOGIC;
    SIGNAL Dir     : STD_LOGIC;

BEGIN

    DUT : ENTITY work.decoder_quadratura
    PORT MAP(
        clk     => clk,
        rst     => rst,
        A_sync  => A_sync,
        B_sync  => B_sync,
        Enable  => Enable,
        Dir     => Dir
    );

    clk <= NOT clk AFTER 10 ns;

    PROCESS
    BEGIN

        WAIT FOR 50 ns;
        rst <= '0';

        WAIT FOR 40 ns;

        A_sync <= '0';
        B_sync <= '0';
        WAIT FOR 40 ns;

        A_sync <= '0';
        B_sync <= '1';
        WAIT FOR 40 ns;

        A_sync <= '1';
        B_sync <= '1';
        WAIT FOR 40 ns;

        A_sync <= '1';
        B_sync <= '0';
        WAIT FOR 40 ns;

        A_sync <= '0';
        B_sync <= '0';
        WAIT FOR 80 ns;

        A_sync <= '1';
        B_sync <= '0';
        WAIT FOR 40 ns;

        A_sync <= '1';
        B_sync <= '1';
        WAIT FOR 40 ns;

        A_sync <= '0';
        B_sync <= '1';
        WAIT FOR 40 ns;

        A_sync <= '0';
        B_sync <= '0';
        WAIT FOR 80 ns;

        WAIT;

    END PROCESS;

END ARCHITECTURE;