	LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.NUMERIC_STD.ALL;
	
	ENTITY DeltaP_a_RPM IS
	PORT(
		 clk       : IN  STD_LOGIC;
		 rst       : IN  STD_LOGIC;
	
		 Tick_40ms : IN  STD_LOGIC;
	
		 DeltaP    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
	
		 RPM       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	END ENTITY;
	
	ARCHITECTURE rtl OF DeltaP_a_RPM IS
	
		 SIGNAL RPM_reg : UNSIGNED(15 DOWNTO 0);
	
	BEGIN
	
	PROCESS(clk,rst)

    VARIABLE DeltaP_int : INTEGER;
    VARIABLE RPM_int    : INTEGER;

BEGIN

    IF rst='1' THEN

        RPM_reg <= (OTHERS => '0');

    ELSIF rising_edge(clk) THEN

        IF Tick_40ms='1' THEN

            DeltaP_int := TO_INTEGER(UNSIGNED(DeltaP));

            RPM_int := (DeltaP_int ) / 88;

            RPM_reg <= TO_UNSIGNED(RPM_int,16);

        END IF;

    END IF;

END PROCESS;
	
	RPM <= STD_LOGIC_VECTOR(RPM_reg);

END ARCHITECTURE;