LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Temporizador_TS IS
PORT(

    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;

    Tick_TS : OUT STD_LOGIC

);
END ENTITY;

ARCHITECTURE rtl OF Temporizador_TS IS

BEGIN

    TIMER : ENTITY work.contador_uni
    GENERIC MAP(
        N => 21
    )
    PORT MAP(

        clk => clk,
        rst => rst,

        ena => '1',

        syn_clr => '0',

        ini => (OTHERS => '0'),

        up => '1',

        max => "111101000101001100001",

        max_tick => Tick_TS,

        counter => OPEN

    );

END ARCHITECTURE;