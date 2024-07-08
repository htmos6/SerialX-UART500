library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_Rx is
generic 
(
	c_clk_frequency : integer := 100_000_000;
	c_baud_rate : integer := 115_800
);
port 
(
	clk_i : in std_logic;
	rx_line_i : in std_logic;
	rx_line_o : out std_logic_vector(7 downto 0);
	rx_completed_o : out std_logic
);
end entity;




architecture Behavioral of UART_Rx is
	
	type S_STATE is (IDLE, START, TRANSMISSION, STOP);
	
	constant c_bit_timer_limit : integer := c_clk_frequency / c_baud_rate; 
	constant c_bit_timer_half_limit : integer := c_bit_timer_limit / 2; 


	signal bit_timer : integer range 0 to c_bit_timer_limit := 0;
	signal bit_counter : integer range 0 to 7 := 0;
	signal state : S_STATE := IDLE;
	
	signal rx_line_SHR : std_logic_vector(7 downto 0) := X"00";
	signal stop_bit_counter : integer range 0 to 2 := 0;
begin

	rx_line_o <= rx_line_SHR; 


	P_Receive : process(clk_i) begin
	if (rising_edge(clk_i)) then
	
		case state is 
		
			when IDLE =>
			    rx_completed_o <= '0';
				bit_timer <= 0;
				stop_bit_counter <= 0;
				
				if (rx_line_i = '0') then
					state <= START;
				end if;
				
			when START =>
			
				if (bit_timer = c_bit_timer_half_limit - 1) then
					state <= TRANSMISSION;
					bit_counter <= 0;
					bit_timer <= 0;
				else
					bit_timer <= bit_timer + 1;
				end if;		
			
			when TRANSMISSION =>
				
				if (bit_timer = c_bit_timer_limit - 1) then
						
					if (bit_counter = 7) then 
						state <= STOP;
						bit_counter <= 0;
					else 
						bit_counter <= bit_counter + 1;
					end if;
					
					rx_line_SHR(0) <= rx_line_i;
					rx_line_SHR(7 downto 1) <= rx_line_SHR(6 downto 0);
					bit_timer <= 0;			
				else
					bit_timer <= bit_timer + 1;
				end if;
			
			when STOP =>
				if (bit_timer = c_bit_timer_limit - 1) then
					
					if (stop_bit_counter < 1) then 
					
						if (rx_line_i = '1') then 
							stop_bit_counter <= stop_bit_counter + 1;
						else 
							stop_bit_counter <= 0;
							rx_completed_o <= '0';
							state <= IDLE;
						end if;
					
					else 
						stop_bit_counter <= 0;
						rx_completed_o <= '1';
						state <= IDLE;
					end if;
				
					bit_timer <= 0;	
				else
					bit_timer <= bit_timer + 1;
				end if;
				
				
		end case;
		
		
	end if;
	end process;






end architecture;
