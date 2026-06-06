LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MOTOR_CONTROL_TOP IS
PORT(
    clk    : IN  STD_LOGIC;
    rst    : IN  STD_LOGIC;

    ENC_A  : IN  STD_LOGIC;
    ENC_B  : IN  STD_LOGIC;

    IN1    : OUT STD_LOGIC;
    IN2    : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE structure OF MOTOR_CONTROL_TOP IS

    SIGNAL posicion_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL deltaP_s   : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL potencia_s : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL referencia_s : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL tick_40ms : STD_LOGIC;

BEGIN


    referencia_s <= x"00000015";


    ENCODER : ENTITY work.Encoder_Completo
    PORT MAP(
        clk               => clk,
        rst               => rst,
        ENC_A             => ENC_A,
        ENC_B             => ENC_B,
        Posicion_Continua => posicion_s,
        DeltaP            => deltaP_s
    );

    TIMER_CONTROL : ENTITY work.contador_uni
    GENERIC MAP(
        N => 21
    )
    PORT MAP(
        clk      => clk,
        rst      => rst,
        ena      => '1',
        syn_clr  => '0',
        ini      => (OTHERS => '0'),
        up       => '1',

        max      => "111101000101001100001",

        max_tick => tick_40ms,
        counter  => OPEN
    );


    CONTROLADOR : ENTITY work.CONTROLADOR_PI
    PORT MAP(
        clk        => clk,
        rst        => rst,

        Tick_40ms  => tick_40ms,

        Referencia => referencia_s,

        DeltaP     => deltaP_s,

        Potencia   => potencia_s
    );


    DRIVER_PWM : ENTITY work.PWM_MOTOR_CONTROLLER
    PORT MAP(
        CLK      => clk,
        RST      => rst,
        POTENCIA => potencia_s,
        IN1      => IN1,
        IN2      => IN2
    );

END ARCHITECTURE;