library ieee ;
use ieee.std_logic_1164.all;

entity i2c_master is
  port(
       reset_n , enable : in std_logic ;
       clk : in std_logic ;
       scl : out std_logic ;
       sda : inout std_logic );
end entity ;

architecture arch of i2c_master is
  
  signal ADDR    : std_logic_vector(6 downto 0):= "1010001";         --Slave Addresse
  signal WR_Bit : std_logic := '0' ;                                 --Write & Read Bit
  signal ADDR_WR : std_logic_vector(7 downto 0);                     --Slave address + WR_bit
  signal DATA    : std_logic_vector(7 downto 0):= "11010010";        --DATA to send
  type State_Type is (IDLE , START , Send_ADDR_WR , ACK1 ,WRITE_DATA,
                      Read_DATA , ACK2 , STOP);  
  signal present_state , next_state : State_Type ; 
  signal ACK_bits  : std_logic_vector(1 downto 0);                   --Slave Reponse  
  signal counter  : integer range 0 to 8  ;
  signal index  : integer range 0 to 7 :=0  ;       
  signal dcl_clk , scl_clk  : std_logic ;                            --Data Clock
  
  --Clock Generator ------------------------
  component clk_gen is
    port (
      clk_100MHz: in std_logic  ;
      scl , dcl: out std_logic);
  end component;

BEGIN 
  ------------------CLK_GEN----------------------------------
       C_Clk_Gen : clk_gen
       port map(
          clk_100MHz =>  CLK ,
          scl        =>  scl_clk ,
          dcl        =>  dcl_clk );
  -----------------------------------------------------------      
     
  ADDR_WR <= ADDR & WR_Bit ;
  
  -----------Update of the state---------------------------
  
  p1: process(reset_n , dcl_clk)
  begin
      if(reset_n ='0') then
        present_state <= IDLE;
        index <= 0 ;
      elsif rising_edge(dcl_clk) then
        if( index = counter - 1  ) then
          present_state <= next_state;
          index <= 0 ;
        else
          index <= index + 1;
        end if;
      end if;
  end process;
  ------------------------------------------------------------------------
  
  p2: process(dcl_clk)
  begin
    if(dcl_clk'event and dcl_clk ='0') then
      if( present_state = ACK1 ) then
          ACK_bits(0) <= sda;
      elsif( present_state = ACK2) then
          ACK_bits(1) <= sda;
      end if;
    end if;
  end process;
   
  -----Finite State Machine Process :   -----------------------------------
  FSM : process(reset_n,dcl_clk ,present_state,index,enable )  
   begin 
     
         case present_state is 
   ----------------IDLE State --------------------
            when IDLE  => scl <= '1' ;
                          sda <= '1' ;
                          counter <= 1;
                          if(enable = '1' ) then
                            next_state <= START ;
                          else
                            next_state <= IDLE ;
                          end if ;
                          
   ----------------START State --------------------            
            when START => scl <= '1' ;
                          sda <= dcl_clk ;
                          counter <= 1;
                          next_state <= Send_ADDR_WR ; 
 
    ----------------Send Slave Address State --------------------           
            when Send_ADDR_WR => scl <= scl_clk ;
                                 sda <= ADDR_WR(7 - index) ;
                                 counter <= 8 ;
                                 next_state <= ACK1 ;             
            
    ----------------ACK1 State ----------------------------------          
            when ACK1 => scl <= scl_clk ;
                         sda <= 'Z' ;
                         counter <= 1;
		                     if WR_bit = '0' then 
		                      next_state <= WRITE_DATA ;
		                     else 
		                      next_state <= Read_DATA ;
		                     end if ;
	
    ---------------- WRITE DATA State --------------------------           
            when WRITE_DATA => scl <= scl_clk ;
                               sda <= DATA(7 - index) ;
                               counter <= 8 ;
                               next_state <= ACK2 ;             
            
    ---------------- READ DATA State --------------------------           
            when READ_DATA => scl <= scl_clk ;
                              DATA(7 - index) <= sda ;
                              counter <= 8 ;
                              next_state <= ACK2 ;      
                                      
   ------------------ ACK2 State -----------------------------         
            when ACK2 => scl <= scl_clk ;
                         sda <= 'Z' ;
                         counter <= 1 ;
                         next_state <= STOP ;             
 
   -------------------- STOP State -----------------------------         
            when STOP => scl <= '1' ;
                         sda <= not dcl_clk ;
                         counter <= 1 ;
                         next_state <= IDLE ;             
            
         end case ; 
   end process ;
  
end arch ;