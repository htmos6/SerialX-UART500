library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_Tx is
	generic 
	(
		c_clk_frequency : integer := 100_000_000; -- 10 ns for 1 period
		c_baud_rate : integer := 115_800; -- 8.63 us
		c_num_of_stop_bit : integer := 2
	);
	port 
	(
		clk_i : in std_logic;
		data_i : in std_logic_vector(7 downto 0);
		start_i : in std_logic;
		tx_line_o : out std_logic;
		tx_completed_o : out std_logic	
	);
end entity;




architecture Behavioral of UART_Tx is

	type S_STATE is (IDLE, START, TRANSMISSION, STOP);
	
	constant c_bit_timer_limit : integer := c_clk_frequency / c_baud_rate;
	constant c_stop_bit_timer_limit : integer := c_bit_timer_limit * 2;
	
	signal SHR : std_logic_vector (7 downto 0) := (others => '0');
	signal state : S_STATE := IDLE;
	signal bit_counter : integer range 0 to 7 := 0;
	signal bit_timer : integer range 0 to c_bit_timer_limit := 0;
	
begin

	P_STATE : process (clk_i) begin
		if (rising_edge(clk_i)) then 
			 	
			case state is 
			
				when IDLE =>
					tx_line_o <= '1';	 						
					tx_completed_o <= '0';	 	

					if (start_i = '1') then 
						state <= START;	
						SHR <= data_i;
						tx_line_o <= '0';
					end if;
				
				when START =>
					if (bit_timer = c_bit_timer_limit - 1) then
						state <= TRANSMISSION;	
						tx_line_o <= SHR(0);
						tx_completed_o <= '0';	 
						SHR(7) <= SHR(0);
						SHR(6 downto 0) <= SHR(7 downto 1);
						
						bit_counter <= 0; -- Shows the sent bit at the corresponding cycle
						bit_timer <= 0;
					else 
						bit_timer <= bit_timer + 1;					
					end if;
			
				when TRANSMISSION =>
					if (bit_timer = c_bit_timer_limit - 1) then
						
						if (bit_counter = 7) then
							state <= STOP;
							tx_line_o <= '1';
							tx_completed_o <= '0';	 
							bit_counter <= 0;
						else 
							tx_line_o <= SHR(0);
							tx_completed_o <= '0';	 
							SHR(7) <= SHR(0);
							SHR(6 downto 0) <= SHR(7 downto 1);
							bit_counter <= bit_counter + 1;
						end if;
						
						bit_timer <= 0;
					else 
						bit_timer <= bit_timer + 1;					
					end if;
				
				when STOP =>
					if (bit_timer = c_stop_bit_timer_limit - 1) then
						state <= IDLE;
						tx_completed_o <= '1';	
						bit_timer <= 0;						
					else 
						bit_timer <= bit_timer + 1;		
					end if;
			end case;

		end if;
	end process;
	
	
	
	




end architecture;
