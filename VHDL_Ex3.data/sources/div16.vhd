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


	begin
		if rstn = '0' then
	
	        -- STUDENT CODE HERE
			--result <= (others => '0');

            -- STUDENT CODE until HERE
		elsif rising_edge(clk) then
		
    		-- STUDENT CODE HERE
			-- Reinschaufeln
			r_remainder(1) <= unsigned(a(15 downto 0));
				--priority encoder to determine the amount of bitshifts
				IF b(7) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),8);
				ELSIF b(6) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),9);
				ELSIF b(5) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),10);				
				ELSIF b(4) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),11);
				ELSIF b(3) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),12);
				ELSIF b(2) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),13);
				ELSIF b(1) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),14);
				ELSIF b(0) = '1' THEN
					r_shifted_b(1)(7 downto 0) <= shift_left(unsigned(b),15);
				END IF;





			-- Berechnen
				-- Vergleicher
					--R1
					FOR i IN 1 TO 8 LOOP
						IF r_remainder(i) <  r_shifted_b(i) THEN
						r_result(i)(0) <= '0';
						ELSE
						r_result(i)(0) <= '1';
						END IF;
					END LOOP;




				-- Subtrahierer

				-- Shift Divisor

			
			-- Weitergeben
			r_remainder(2 to 9) <= r_remainder(1 to 8);
			r_shifted_b(2 to 9) <= r_shifted_b(1 to 8);
			r_result(2 to 9) <= r_result(1 to 8);
	
			-- Rausschaufeln
			r_result_signed(7 downto 0) <= signed(r_remainder(9)(7 downto 0)); --Result anstatt Remainder
			-- STUDENT CODE until HERE
		end if;
	end process;
	
	result <= STD_LOGIC_VECTOR(r_result_signed);

end architecture rtl;
