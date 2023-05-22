library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;
use std.textio.all;

entity div16_8_8 is
	generic(
		A_WIDTH			: POSITIVE := 17;
		B_WIDTH			: POSITIVE := 8;
		RESULT_WIDTH	: POSITIVE := 9
	);
	port (
		clk        : in  STD_LOGIC;
		en         : in  STD_LOGIC;
		rstn       : in  STD_LOGIC;
		a          : in  STD_LOGIC_VECTOR( A_WIDTH-1 downto 0);
		b          : in  STD_LOGIC_VECTOR( B_WIDTH-1 downto 0);
		result     : out STD_LOGIC_VECTOR( RESULT_WIDTH-1 downto 0)		
	);
end entity div16_8_8;

architecture rtl of div16_8_8 is

    type unsigned_8_array  is array(natural range <>) of UNSIGNED( 7 downto 0);
	type unsigned_16_array is array(natural range <>) of UNSIGNED(15 downto 0);

	signal r_remainder 		: unsigned_16_array(1 to 9);
	signal r_shifted_b 		: unsigned_16_array(1 to 9);
	signal r_result    		: unsigned_8_array (1 to 9);
	signal r_result_signed 	: SIGNED(8 downto 0);
	signal r_sign      		: STD_LOGIC_VECTOR(1 to 9);
	signal r_en		     	: STD_LOGIC_VECTOR(1 to 9);
begin

	process(clk, rstn, en)
		variable v_result 	: UNSIGNED( 8 downto 1);
        variable a_signed 	: SIGNED(16 downto 0);
        variable a_unsigned : UNSIGNED(15 downto 0);
		variable b_unsigned : UNSIGNED(15 downto 0);


	begin
		if rstn = '0' then
	
	        -- STUDENT CODE HERE
			r_en <= (others => '0');
			r_sign <= (others => '0');
			r_result_signed <= (others => '0');


			FOR i IN 1 TO 9 LOOP
				r_remainder(i) <= (others => '0');
				r_shifted_b(i) <= (others => '0');
				r_result(i) <= (others => '0');


			END LOOP;

            -- STUDENT CODE until HERE
		elsif rising_edge(clk) then
		
    		-- STUDENT CODE HERE
			-- Initialisieren
				r_remainder(1) 	<= (others => '0');
				r_shifted_b(1) 	<= (others => '0');
				r_result(1) 	<= (others => '0');
				r_sign <= (others => '0');
				--a_signed := (OTHERS => '0');

			-- Reinschaufeln
				--r_remainder(1) <= unsigned(a(15 downto 0));
				--r_shifted_b(1)(15 downto 8) <= unsigned(b);
				IF a(16) = '1' THEN
					r_sign(1) <= '1';
					a_unsigned :=  unsigned((not a(15 downto 0))) + 1;
				ELSE 
					a_unsigned := unsigned(a(15 downto 0));
				END IF;

				b_unsigned := (others => '0');
				b_unsigned(15 downto 8) := unsigned(b);
				r_en(1) <= en;

				IF  a_unsigned <  b_unsigned THEN
					v_result := (others => '0');
					v_result(8) := '0';
					r_remainder(1) <= a_unsigned;
				ELSE
					v_result := (others => '0');
					v_result(8) := '1';
					r_remainder(1) <= (a_unsigned - b_unsigned);

				END IF;
				r_result(1)(7) <= v_result(8);

				r_shifted_b(1) <= (others => '0');
				r_shifted_b(1)((14) downto (7)) <= b_unsigned(15 downto 8);
		

			-- Berechnen
				-- Vergleicher
				
				FOR i IN 1 TO 8 LOOP
					IF r_en(i) = '1' THEN
						IF r_remainder(i) <  r_shifted_b(i) THEN
							v_result := (others => '0');
							v_result(9 - i) := '0';
							r_remainder(i + 1) <= r_remainder(i);
						ELSE
							v_result := (others => '0');
							v_result(9 - i) := '1';
							r_remainder(i + 1) <= (r_remainder(i) - r_shifted_b(i));

						END IF;
						r_sign(i + 1) <= r_sign(i);
						r_result(i + 1) <= r_result(i);
						r_result(i + 1)(8 - i) <= v_result(9 - i);
					END IF;
				END LOOP;
				
				r_en(2 to 9) <= r_en(1 to 8);

				-- Shift Divisor
				FOR i IN 1 to 7 LOOP
					r_shifted_b(i + 1) <= (others => '0');
					r_shifted_b(i + 1)((14 - i) downto (7 - i)) <= r_shifted_b(i)((15 - i) downto (8 - i));
				END LOOP;

			
			-- Weitergeben
			IF r_en(9) = '1' THEN
				IF r_sign(9) = '1' THEN
					IF r_result(9) = 0 THEN 
						r_result_signed <= (others => '0');
					ELSE
						r_result_signed <= '1' & signed((not r_result(9)) + 1);
					END IF;
				ELSE
				r_result_signed <= '0' & signed(r_result(9));
				END IF;
			END IF;

			--r_remainder(2 to 9) <= r_remainder(1 to 8);
			--r_result(2 to 9) <= r_result(1 to 8); -- nicht zwei mal auf ein signal assignen
	
			-- Rausschaufeln
			--r_result_signed <= '0' & unsigned(r_result(9));
			-- STUDENT CODE until HERE
		end if;
		
	end process;
	result <= STD_LOGIC_VECTOR(r_result_signed);

end architecture rtl;
