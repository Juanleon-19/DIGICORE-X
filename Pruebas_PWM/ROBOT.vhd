LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ROBOT IS

PORT(

    CLOCK_50 : IN STD_LOGIC;
    RESET    : IN STD_LOGIC;

    CMD0     : IN STD_LOGIC;
    CMD1     : IN STD_LOGIC;
    CMD2     : IN STD_LOGIC;

    M1_IN1   : OUT STD_LOGIC;
    M1_IN2   : OUT STD_LOGIC;

    M2_IN1   : OUT STD_LOGIC;
    M2_IN2   : OUT STD_LOGIC

);

END ENTITY;

ARCHITECTURE structure OF ROBOT IS

SIGNAL POTENCIA_M1 : STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL POTENCIA_M2 : STD_LOGIC_VECTOR(8 DOWNTO 0);

SIGNAL CMD : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    CMD <= CMD2 & CMD1 & CMD0;

    FSM_MOVIMIENTO : ENTITY work.CONTROL_MOVIMIENTO
    PORT MAP(
			CLK    =>CLOCK_50,
        CMD     => CMD,
			RST    =>RESET,
        POT_M1  => POTENCIA_M1,
        POT_M2  => POTENCIA_M2

    );

    MOTOR1 : ENTITY work.PWM_MOTOR_CONTROLLER
    PORT MAP(

        CLK      => CLOCK_50,
        RST      => RESET,

        POTENCIA => POTENCIA_M1,

        IN1      => M1_IN1,
        IN2      => M1_IN2

    );

    MOTOR2 : ENTITY work.PWM_MOTOR_CONTROLLER
    PORT MAP(

        CLK      => CLOCK_50,
        RST      => RESET,

        POTENCIA => POTENCIA_M2,

        IN1      => M2_IN1,
        IN2      => M2_IN2

    );

END ARCHITECTURE;