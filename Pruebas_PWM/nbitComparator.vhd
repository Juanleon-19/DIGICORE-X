------------------------------------------------------------------------------------------
--                                                                                      --
--                              Juan Esteban Leon Saiz                                  --
--                                                                                      --
--  Project: COMPARATORS                                                                            --
--  Date: 25/02/2026                                                                               --
--                                                                                      --
------------------------------------------------------------------------------------------
--                                                                                      --
--                                                                                      --
--                                                                                      --
--                                                                                      --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------------------------------------------------------------------
-- 
-- 
-- 
------------------------------------------------------------------------------------------

ENTITY nbitComparator IS
    
	 GENERIC (MAX_WIDTH : INTEGER := 9);
    PORT   (
				X : IN STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
				Y : IN STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
				eq : OUT STD_LOGIC;
				lg : OUT STD_LOGIC;
				lS: OUT STD_LOGIC
		
		
           );
    
END ENTITY nbitComparator;



ARCHITECTURE gateLevel OF nbitComparator IS

	SIGNAL 	EQS	 : STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
BEGIN

		eq <= '1' WHEN X = Y ELSE '0';
		lg <= '1' WHEN X > Y ELSE '0';
		ls <= '1' WHEN X < Y ELSE '0';
		

END gateLevel;