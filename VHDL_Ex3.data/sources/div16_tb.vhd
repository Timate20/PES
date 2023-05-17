
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use std.textio.all;

ENTITY div16_tb IS
END div16_tb;
 
ARCHITECTURE behavior OF div16_tb IS 


   	
    COMPONENT div16_8_8 is
	port (
		clk        : in  STD_LOGIC;
		en         : in  STD_LOGIC;
		rstn       : in  STD_LOGIC;
		a          : in  STD_LOGIC_VECTOR(16 downto 0);
		b          : in  STD_LOGIC_VECTOR( 7 downto 0);
		result     : out STD_LOGIC_VECTOR( 8 downto 0)		
	);
	end COMPONENT;
    

   --Input
	signal clk						: STD_LOGIC := '0';
	signal en						: STD_LOGIC;
	signal rstn						: STD_LOGIC;
	
	signal input_a          : STD_LOGIC_VECTOR(16 downto 0);
	signal input_b          : STD_LOGIC_VECTOR( 7 downto 0);
	signal result     : STD_LOGIC_VECTOR( 8 downto 0);
	
	signal cnt1, cnt2		: integer := 0;-- range 0 to 17;
	signal pipeline_length	: integer := 0;-- range 0 to 17;
	signal take_result : std_logic := '0';
	
	type input_a_arr_type is array (natural range <>) of  STD_LOGIC_VECTOR(16 downto 0);
	type input_b_arr_type is array (natural range <>) of  STD_LOGIC_VECTOR(7 downto 0);
	type result_arr_type is array (natural range <>) of  STD_LOGIC_VECTOR(8 downto 0);
	
	constant input_a_arr : input_a_arr_type (0 to 17) := ( std_logic_vector(to_signed(42,17)), --0
																		std_logic_vector(to_signed( -255, 17)), 
																		std_logic_vector(to_signed(	-255, 17)),
																		std_logic_vector(to_signed( -42, 17)),
																		std_logic_vector(to_signed( -42, 17)),
																		
																		std_logic_vector(to_signed( -42, 17)),  --5
																		std_logic_vector(to_signed( -35, 17)),
																		std_logic_vector(to_signed( -35, 17)),		
																		std_logic_vector(to_signed( -1,  17)),
																		std_logic_vector(to_signed( 0,  17)),
																		
																		std_logic_vector(to_signed( 1,  17)), --10
																		std_logic_vector(to_signed( 35,  17)),
																		std_logic_vector(to_signed( 35,  17)),
																		std_logic_vector(to_signed( 42,  17)),
																		std_logic_vector(to_signed( 42,  17)),
																		
																		std_logic_vector(to_signed( 42,  17)), --15
																		std_logic_vector(to_signed( 255,  17)),
																		std_logic_vector(to_signed( 255,  17))
	);
	constant input_b_arr : input_b_arr_type (0 to 17) :=  ( std_logic_vector(to_signed(7, 8)), --0
																		std_logic_vector(to_unsigned( 255, 8)), 
																		std_logic_vector(to_unsigned( 1, 8)),
																		std_logic_vector(to_unsigned( 43, 8)),
																		std_logic_vector(to_unsigned( 41, 8)),
															   
																		std_logic_vector(to_unsigned( 7, 8)), --5
																		std_logic_vector(to_unsigned( 5, 8)),
																		std_logic_vector(to_unsigned( 1, 8)),
																		std_logic_vector(to_unsigned( 0, 8)),
																		std_logic_vector(to_unsigned( 1, 8)),
																		
																		std_logic_vector(to_unsigned( 0, 8)), --10
																		std_logic_vector(to_unsigned( 1, 8)),
																		std_logic_vector(to_unsigned( 5, 8)),
																		std_logic_vector(to_unsigned( 7, 8)),
																		std_logic_vector(to_unsigned( 41, 8)),
																		
																		std_logic_vector(to_unsigned( 43, 8)), --15
																		std_logic_vector(to_unsigned( 1, 8)),
																		std_logic_vector(to_unsigned( 255, 8))
	);
	constant result_arr : result_arr_type (0 to 17) :=  ( 	std_logic_vector(to_signed(6,9)),	--0
																		std_logic_vector(to_signed( -1, 9)), 
																		std_logic_vector(to_signed( -255, 9)),
																		std_logic_vector(to_signed( 0, 9)),
																		std_logic_vector(to_signed( -1, 9)),		
																		
																		std_logic_vector(to_signed( -6, 9)), --5
																		std_logic_vector(to_signed( -7, 9)),
																		std_logic_vector(to_signed( -35, 9)),
																		std_logic_vector(to_signed( -255, 9)),
																		std_logic_vector(to_signed( 0, 9)),
																		
																		std_logic_vector(to_signed( 255, 9)), --10
																		std_logic_vector(to_signed( 35, 9)),
																		std_logic_vector(to_signed( 7, 9)),
																		std_logic_vector(to_signed( 6, 9)),
																		std_logic_vector(to_signed( 1, 9)),
																		
																		std_logic_vector(to_signed( 0, 9)), --15
																		std_logic_vector(to_signed( 255, 9)),
																		std_logic_vector(to_signed( 1, 9))
	);


	BEGIN
	
	uut: div16_8_8
	port map(
		clk        => clk   ,
		en         => en    ,
		rstn       => rstn  ,
		a          => input_a,
		b          => input_b,
		result     => result	
	);
	
 	
		

		
   CLK_GEN : process(clk)
	begin
		clk <= not clk after 5 ns;
	end process;
 
   stim_proc: process
   begin		
		wait until rising_edge(clk);
		rstn   <= '0';
		en     <= '0';
		
		cnt1 <= 0;
		
		wait for 100 ns;
		rstn   <= '1';
		
		en  <= '1';
		
		while cnt1 < (input_a_arr'length) loop
			input_a <= input_a_arr(cnt1);
			input_b <= input_b_arr(cnt1);
			cnt1 <= cnt1+1;
			
			wait until rising_edge(clk);
		end loop;
		
		wait;
	end process;
	
	check_result: process(clk)
	begin		
        if rising_edge(clk) then
            if take_result = '1' then
                if cnt2 < 18 then
                    assert result = result_arr(cnt2) 
                    report "Result mismatch: cnt : " & 
                            integer'image(cnt2)	&
                            ", expected : " &
                            integer'image(to_integer(signed(result_arr(cnt2)))) &
                            ", received : " & integer'image(to_integer(signed(result))) 
                            severity failure;
                    
                     cnt2 <= cnt2+1; 
                 else
                    assert pipeline_length >= result'length
                    report "no pipelining implemented!"
                    severity failure;
                 end if;                       
            elsif result = result_arr(cnt2) then
                take_result <= '1';
                pipeline_length <= cnt1;
                cnt2 <= cnt2+1; 
            end if;
        end if;
        
	end process; 
	
	check_result_count: process
    begin        
		wait for 800 ns; 
				
		assert cnt2 = cnt1 and cnt2 = 18
                report "not all results have been checked!"
                severity failure;
				
		assert pipeline_length >= result'length
                report "no pipelining implemented!"
                severity failure;
		
		wait;
    end process;
END;
