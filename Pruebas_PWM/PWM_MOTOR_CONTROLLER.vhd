LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PWM_MOTOR_CONTROLLER IS

    PORT(
        CLK       : IN  STD_LOGIC;
        RST       : IN  STD_LOGIC;
        POTENCIA  : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN1       : OUT STD_LOGIC;
        IN2       : OUT STD_LOGIC
    );

END ENTITY PWM_MOTOR_CONTROLLER;

ARCHITECTURE structure OF PWM_MOTOR_CONTROLLER IS

    SIGNAL tick_divisor   : STD_LOGIC;
    SIGNAL fin_pwm        : STD_LOGIC;

    SIGNAL cuenta_divisor : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cuenta_pwm     : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL potencia_comp2 : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL potencia_mux   : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL potencia_reg   : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL pwm            : STD_LOGIC;

    SIGNAL positivo       : STD_LOGIC;
    SIGNAL negativo       : STD_LOGIC;

    SIGNAL pwm_9bits      : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL cuenta_9bits   : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL igual_pwm      : STD_LOGIC;
    SIGNAL mayor_pwm      : STD_LOGIC;

BEGIN

    positivo <= NOT POTENCIA(8);

    negativo <= POTENCIA(8);

    cuenta_9bits <= '0' & cuenta_pwm;

    pwm_9bits <= '0' & potencia_reg(7 DOWNTO 0);

    COMPLEMENTO_DOS : ENTITY work.Complement_TWO
    PORT MAP(
        A => POTENCIA,
        Y => potencia_comp2
    );

    MUX_POTENCIA : ENTITY work.Mux2_1_Nine_Bit
    PORT MAP(
        x1  => POTENCIA,
        x2  => potencia_comp2,
        sel => negativo,
        y   => potencia_mux
    );

    DIVISOR_FRECUENCIA : ENTITY work.contador_uni
    GENERIC MAP(
        N => 4
    )
    PORT MAP(
        clk      => CLK,
        rst      => RST,
        ena      => '1',
        syn_clr  => '0',
        ini      => "0000",
        up       => '1',
        max      => "1001",
        max_tick => tick_divisor,
        counter  => cuenta_divisor
    );

    CONTADOR_PWM : ENTITY work.contador_uni
    GENERIC MAP(
        N => 8
    )
    PORT MAP(
        clk      => CLK,
        rst      => RST,
        ena      => tick_divisor,--tick_divisor(Para pruebas rapidas)
        syn_clr  => '0',
        ini      => "00000000",
        up       => '1',
        max      => "11111111",
        max_tick => fin_pwm,
        counter  => cuenta_pwm
    );

    REGISTRO_PWM : ENTITY work.REGISTER_N_BITS
    GENERIC MAP(
        MAX_WIDTH => 9
    )
    PORT MAP(
        D   => potencia_mux,
        ENA => fin_pwm,
        RST => RST,
        CLK => CLK,
        Q   => potencia_reg
    );

    COMPARADOR_PWM : ENTITY work.nbitComparator
    GENERIC MAP(
        MAX_WIDTH => 9
    )
    PORT MAP(
        X  => cuenta_9bits,
        Y  => pwm_9bits,
        eq => igual_pwm,
        lg => mayor_pwm,
        ls => pwm
    );

    DEMUX_MOTOR : ENTITY work.demux1_2gates
    PORT MAP(
        x   => pwm,
        sel => negativo,
        y1  => IN1,
        y2  => IN2
    );

END ARCHITECTURE structure;