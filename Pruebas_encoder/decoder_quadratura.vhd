LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decoder_quadratura IS
PORT(
    clk     : IN  STD_LOGIC;
    rst     : IN  STD_LOGIC;
    A_sync  : IN  STD_LOGIC;
    B_sync  : IN  STD_LOGIC;
    Enable  : OUT STD_LOGIC;
    Dir     : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE rtl OF decoder_quadratura IS

    TYPE state_type IS (
        S00,
        S01,
        S11,
        S10
    );

    SIGNAL state      : state_type;
    SIGNAL next_state : state_type;

    SIGNAL enable_s   : STD_LOGIC;
    SIGNAL dir_s      : STD_LOGIC;

BEGIN

PROCESS(clk,rst)
BEGIN

    IF rst='1' THEN
        state <= S00;

    ELSIF rising_edge(clk) THEN
        state <= next_state;

    END IF;

END PROCESS;

PROCESS(state,A_sync,B_sync)
BEGIN

    next_state <= state;

    enable_s <= '0';
    dir_s    <= '0';

    CASE state IS

        WHEN S00 =>

            IF (A_sync='0' AND B_sync='0') THEN

                next_state <= S00;

            ELSIF (A_sync='0' AND B_sync='1') THEN

                next_state <= S01;
                enable_s <= '1';
                dir_s <= '1';

            ELSIF (A_sync='1' AND B_sync='0') THEN

                next_state <= S10;
                enable_s <= '1';
                dir_s <= '0';

            END IF;

        WHEN S01 =>

            IF (A_sync='0' AND B_sync='1') THEN

                next_state <= S01;

            ELSIF (A_sync='1' AND B_sync='1') THEN

                next_state <= S11;
                enable_s <= '1';
                dir_s <= '1';

            ELSIF (A_sync='0' AND B_sync='0') THEN

                next_state <= S00;
                enable_s <= '1';
                dir_s <= '0';

            END IF;

        WHEN S11 =>

            IF (A_sync='1' AND B_sync='1') THEN

                next_state <= S11;

            ELSIF (A_sync='1' AND B_sync='0') THEN

                next_state <= S10;
                enable_s <= '1';
                dir_s <= '1';

            ELSIF (A_sync='0' AND B_sync='1') THEN

                next_state <= S01;
                enable_s <= '1';
                dir_s <= '0';

            END IF;

        WHEN S10 =>

            IF (A_sync='1' AND B_sync='0') THEN

                next_state <= S10;

            ELSIF (A_sync='0' AND B_sync='0') THEN

                next_state <= S00;
                enable_s <= '1';
                dir_s <= '1';

            ELSIF (A_sync='1' AND B_sync='1') THEN

                next_state <= S11;
                enable_s <= '1';
                dir_s <= '0';

            END IF;

    END CASE;

END PROCESS;

Enable <= enable_s;
Dir    <= dir_s;

END ARCHITECTURE;