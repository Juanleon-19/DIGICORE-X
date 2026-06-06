LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY Flip_Flop_D_RE IS
    
   
    PORT   (
				D : IN STD_LOGIC;
				ENA : IN STD_LOGIC;
				RST : IN STD_LOGIC;
				CLK : IN STD_LOGIC;				
				Q : OUT STD_LOGIC
		
		
           );
    
END ENTITY ;



ARCHITECTURE rtl OF Flip_Flop_D_RE IS


BEGIN

		Flip_Flop_D_RE: PROCESS (CLK, RST, D)
		BEGIN
			IF (RST = '1') THEN
				Q<='0';
			ELSIF (rising_edge(CLK)) THEN
				IF (ENA = '1') THEN
					Q <= D;
				END IF;
			END IF;
		END PROCESS;
		
END rtl;