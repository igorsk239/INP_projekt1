-- ledc8x8.vhd: INP Project 1, programming matrix displey 8x8
-- Author: Igor Ignac - xignac00 
-- Using components codes from INP lectures 2017/2018
--	VUT FIT 2017/2018

-- ----------------------------------------------------------------------------
--                        			Libraries
-- ----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        			Entity
-- ----------------------------------------------------------------------------
entity ledc8x8 is
port ( 
			SMCLK, RESET: in std_logic;
			ROW, LED: out std_logic_vector(0 to 7)
);
end ledc8x8;

-- ----------------------------------------------------------------------------
--                        			Signals
-- ----------------------------------------------------------------------------
architecture main of ledc8x8 is
	signal leds, rows: std_logic_vector(7 downto 0);
	signal ce_gen: std_logic_vector(7 downto 0);
	signal ce: std_logic := '0';

begin

-- ----------------------------------------------------------------------------
--                     				 Rotation
-- ----------------------------------------------------------------------------		
	rotation: process(SMCLK, RESET, ce)
	begin
		if RESET= '1' then
			rows <= "10000000";
		elsif (SMCLK'event and SMCLK='1' and ce = '1') then
			rows <= rows(0) & rows(7 downto 1);
		end if;
	end process rotation;

-- ----------------------------------------------------------------------------
--                      Counter for lowering a frequency
-- ----------------------------------------------------------------------------
	ce_generator: process(SMCLK, RESET)
	begin
		if RESET = '1' then
			ce_gen <= "00000000";
			
		elsif SMCLK'event and SMCLK = '1' then
			ce_gen <= ce_gen + 1;
		end if;
	end process ce_generator;
	ce <= '1' when ce_gen = X"FF" else '0'; --SMCLK/256

-- ----------------------------------------------------------------------------
--                        			Decoder for rows
-- ----------------------------------------------------------------------------
	decoder: process(rows)
	begin
			case rows is
				when "10000000" => leds <= "00011000";
				when "01000000" => leds <= "10111101";
				when "00100000" => leds <= "10111101";
				when "00010000" => leds <= "10111101";
				when "00001000" => leds <= "10111101";
				when "00000100" => leds <= "10111101";
				when "00000010" => leds <= "10111101";
				when "00000001" => leds <= "00011000";
				when others 	 => leds <= "11111111";
			end case;
	end process decoder;		
	
-- ----------------------------------------------------------------------------
--                        			Lighting up LEDS
-- ----------------------------------------------------------------------------
	ROW <= rows;
	LED <= leds;
end main;