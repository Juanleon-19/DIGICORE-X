LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TB_PWM_MOTOR_CONTROLLER IS
END ENTITY;

ARCHITECTURE TB OF TB_PWM_MOTOR_CONTROLLER IS

    SIGNAL CLK       : STD_LOGIC := '0';
    SIGNAL RST       : STD_LOGIC := '0';

    SIGNAL POTENCIA  : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL IN1       : STD_LOGIC;
    SIGNAL IN2       : STD_LOGIC;

BEGIN

    DUT : ENTITY work.PWM_MOTOR_CONTROLLER
    PORT MAP(
        CLK      => CLK,
        RST      => RST,
        POTENCIA => POTENCIA,
        IN1      => IN1,
        IN2      => IN2
    );

    PROCESS
    BEGIN

        CLK <= '0';
        WAIT FOR 10 ns;

        CLK <= '1';
        WAIT FOR 10 ns;

    END PROCESS;

    PROCESS
    BEGIN

        RST <= '1';
        POTENCIA <= "000000000";

        WAIT FOR 100 ns;

        RST <= '0';

        POTENCIA <= "001000000";
        WAIT FOR 1 ms;

        POTENCIA <= "010000000";
        WAIT FOR 1 ms;

        POTENCIA <= "011111111";
        WAIT FOR 1 ms;

        POTENCIA <= "100000001";
        WAIT FOR 1 ms;

        POTENCIA <= "110000000";
        WAIT FOR 1 ms;

        POTENCIA <= "111111111";
        WAIT FOR 1 ms;

        POTENCIA <= "000000000";

        WAIT;

    END PROCESS;

END ARCHITECTURE;