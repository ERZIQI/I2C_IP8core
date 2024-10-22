LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY clk_gen_tb  IS 
END ; 
 
ARCHITECTURE clk_gen_tb_arch OF clk_gen_tb IS
  SIGNAL clk_100MHz   :  STD_LOGIC  ; 
  SIGNAL scl   :  STD_LOGIC  ; 
  SIGNAL dcl   :  STD_LOGIC  ; 
  COMPONENT clk_gen  
    PORT ( 
      clk_100MHz  : in STD_LOGIC ; 
      scl  : out STD_LOGIC ; 
      dcl  : out STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : clk_gen  
    PORT MAP ( 
      clk_100MHz   => clk_100MHz  ,
      scl   => scl  ,
      dcl   => dcl   ) ; 
  
  Clk_1MHz : process
   Begin 
     clk_100MHz <= '0' ;
     wait for 5 ns ;
     clk_100MHz <= '1' ;
     wait for 5 ns ;
   End process ;

END ; 

