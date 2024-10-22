library ieee;
use ieee.std_logic_1164.all;

entity clk_gen is
port (
      clk_100MHz: in std_logic  ;
      scl , dcl: out std_logic);
end entity;

architecture arch of clk_gen is
  
 signal count: natural range 0 to 11:=0;
 signal count2: integer range 0 to 3:=0;
 signal clk_4MHz: std_logic:='0';
 signal scl_clk, dcl_clk: std_logic:='0';
begin
  
 process(clk_100MHz)
  begin
    if rising_edge(clk_100MHz) then  
      if(count = 11) then
       clk_4MHz <= not clk_4MHz;
       count <= 0;
      else 
       count <= count + 1; 
      end if;
    end if;
 end process;
 
 
 clk1MHz: process (clk_4MHz)
 begin
 if(rising_edge(clk_4MHz)) then
  if(count2 = 0) then
      scl_clk <= '0';
  elsif(count2 = 1) then
      dcl_clk <= '1';
  elsif(count2 = 2) then
      scl_clk <= '1';
  else
      dcl_clk <= '0';
  end if;
  if(count2 = 3) then
      count2 <= 0;
  else
      count2 <= count2 + 1;
  end if;
  end if;
 end process;
  scl <= scl_clk ;
  dcl <= dcl_clk ;
end architecture;