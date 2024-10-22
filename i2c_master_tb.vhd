LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY i2c_master_tb  IS 
END ; 
 
ARCHITECTURE i2c_master_tb_arch OF i2c_master_tb IS
  SIGNAL sda   :  STD_LOGIC  ; 
  SIGNAL rst   :  STD_LOGIC  ; 
  SIGNAL scl   :  STD_LOGIC  ; 
  SIGNAL clk   :  STD_LOGIC  ; 
  SIGNAL enable   :  STD_LOGIC  ; 
  COMPONENT i2c_master  
    PORT ( 
      sda  : inout STD_LOGIC ; 
      rst  : in STD_LOGIC ; 
      scl  : out STD_LOGIC ; 
      clk  : in STD_LOGIC ; 
      enable  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : i2c_master  
    PORT MAP ( 
      sda   => sda  ,
      rst   => rst  ,
      scl   => scl  ,
      clk   => clk  ,
      enable   => enable   ) ;
      
  Clk_1MHz : process
   Begin 
     clk <= '0' ;
     wait for 5 ns ;
     clk <= '1' ;
     wait for 5 ns ;
   End process ; 
   
  rst <= '0' after 20 ns ;
  enable <= '1' after 20 ns ;
END ; 

