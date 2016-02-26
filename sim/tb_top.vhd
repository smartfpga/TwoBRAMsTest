----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2016 13:46:19
-- Design Name: 
-- Module Name: tb_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

component two_brams_test_wrapper is
port (
  addra_cm : in STD_LOGIC_VECTOR ( 31 downto 0 );
  addra_sam : in STD_LOGIC_VECTOR ( 9 downto 0 );
  addrb_cm : in STD_LOGIC_VECTOR ( 31 downto 0 );
  addrb_sam : in STD_LOGIC_VECTOR ( 9 downto 0 );
  clk_in : in STD_LOGIC;
  dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
  doutb_cm : out STD_LOGIC_VECTOR ( 31 downto 0 );
  doutb_sam : out STD_LOGIC_VECTOR ( 31 downto 0 );
  ena : in STD_LOGIC;
  enb : in STD_LOGIC;
  rst_in : in STD_LOGIC;
  wea_cm : in STD_LOGIC_VECTOR ( 3 downto 0 );
  wea_sam : in STD_LOGIC_VECTOR ( 0 downto 0 )
);
end component;

signal address_wr   : STD_LOGIC_VECTOR (31 downto 0);
signal address_rd   : STD_LOGIC_VECTOR (31 downto 0);
signal increment_addr  : STD_LOGIC_VECTOR (31 downto 0);

signal clock        : STD_LOGIC;

signal data_wr          : STD_LOGIC_VECTOR (31 downto 0);
signal data_rd_cm       : STD_LOGIC_VECTOR (31 downto 0);
signal data_rd_sam      : STD_LOGIC_VECTOR (31 downto 0);
signal wr_ports_enable  : STD_LOGIC_VECTOR (3 downto 0);
signal rd_ports_enable  : STD_LOGIC;
signal rst              : STD_LOGIC;


constant clock_period : time := 10 ns;

begin
    
    BD_inst: two_brams_test_wrapper port map (
            addra_cm    =>  address_wr,
            addra_sam   =>  address_wr(9 downto 0),
            addrb_cm    =>  address_rd,
            addrb_sam   =>  address_rd(9 downto 0),
            clk_in      =>  clock,
            dina        =>  data_wr,
            doutb_cm    =>  data_rd_cm,
            doutb_sam   =>  data_rd_sam, 
            ena         =>  wr_ports_enable(0),
            enb         =>  rd_ports_enable,
            rst_in      =>  rst,
            wea_cm      =>  wr_ports_enable,
            wea_sam     =>  wr_ports_enable (0 downto 0)
            );

   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 
 -- Stimulus process
   rst_proc: process 
   begin
        rst <= '1';		
        -- hold reset state for 100 ns.
        wait for 50 ns;	
        -- insert stimulus here 
        rst <= '0';
        wait;
    end process;


    wr_address_assignment: process 
    begin
        address_wr      <= (others => '0');
        address_rd      <= (others => '0');
        increment_addr  <= (others => '0');
        
        wr_ports_enable <= (others => '0');
        rd_ports_enable <= '0';
        
        wait until rst = '0';
        
        wr_ports_enable <= (others => '1');
        for i in 1 to 256 loop 
            wait until clock = '1';
            address_wr <= address_wr + '1';
        end loop;
        
        rd_ports_enable <= '1';        
        wr_ports_enable <= (others => '0');
        for i in 1 to 256 loop 
            wait until clock = '1';           
            address_rd <= increment_addr;
            increment_addr <= increment_addr + '1';  
         end loop;
        wait;

    end process;    


      
    data_wr <= address_wr; -- es wird der Adresswert unter der jeweiligen Adresse gespeichert 
    
end Behavioral;
