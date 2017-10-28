----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2017 02:47:09 PM
-- Design Name: 
-- Module Name: lab7_divider - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
entity seven_segment is
    port (a1,a0,b1,b0: in std_logic_vector(3 downto 0); clock: in std_logic ;
          anode: out std_logic_vector(3 downto 0); cathode: out std_logic_vector(6 downto 0));
    end seven_segment;
architecture behav of seven_segment is
        begin
            process(clock)
            variable num : std_logic_vector(3 downto 0);
            variable disp : integer:=1;
            begin
                if(clock='1' and clock'event) then
                    if(disp=4) then disp:=1;
                    else disp:=disp+1;
                    end if;
    
                    case disp is
                        when 4 => anode<= "1110"; num:=b0;
                        when 3 => anode<= "1101"; num:=b1;
                        when 2 => anode<= "1011"; num:=a0;
                        when 1 => anode<= "0111"; num:=a1;
                        when others =>anode<="0000";
                    end case;
    
                    case num is
                        when "0000" => cathode<="1000000"; --40
                        when "0001" => cathode<="1111001"; --79
                        when "0010" => cathode<="0100100"; --24
                        when "0011" => cathode<="0110000"; --30
                        when "0100" => cathode<="0011001"; --19
                        when "0101" => cathode<="0010010"; --12
                        when "0110" => cathode<="0000010"; --2
                        when "0111" => cathode<="1111000"; --78
                        when "1000" => cathode<="0000000"; --0
                        when "1001" => cathode<="0010000"; --10
                        
                        when "1010" => cathode<="0001000"; --8
                        when "1011" => cathode<="0000011"; --3
                        when "1100" => cathode<="1000110"; --46
                        when "1101" => cathode<="0100001"; --21
                        when "1110" => cathode<="0000110"; --6
                        when others => cathode<="0001110"; --e
                    end case;
                end if;
            end process;
    end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
entity divider is
    port( divisor: in std_logic_vector(7 downto 0);
          dividend:in std_logic_vector(7 downto 0);
          output_valid:out std_logic;
          input_invalid:out std_logic;
          load_inputs:in std_logic;
          qoutient:out std_logic_vector(7 downto 0);
          remain:out std_logic_vector(7 downto 0)
        );
end divider;

architecture behav of divider is
begin
    process(load_inputs)
    variable r:std_logic_vector(15 downto 0);
    variable q:std_logic_vector(7 downto 0);
    variable d:std_logic_vector(7 downto 0);
    variable rh:std_logic_vector(7 downto 0);
    variable c:std_logic_vector(8 downto 0);
    variable f:std_logic_Vector(8 downto 0);
begin
    output_valid<='0';
    if(divisor="00000000") then input_invalid<='1';output_valid<='0';
    
    else
        r(15 downto 8):="00000000";
        r(7 downto 0):=dividend;
        d:=divisor;
        q:="00000000";
        if(r(7 downto 0)="10000000") then r(7 downto 0):="10000000";
        elsif(r(7)='1') then
            c(7 downto 0):=r(7 downto 0);
            c(8):='0';
            c:="100000000"-c;
            r(7 downto 0):=c(7 downto 0);
        end if;

        if(d(7 downto 0)="10000000") then d(7 downto 0):="10000000";
        elsif(d(7)='1') then
            c(7 downto 0):=d(7 downto 0);
            c(8):='0';
            c:="100000000"-c;
            d(7 downto 0):=c(7 downto 0);
        end if;

    X: for i in 0 to 7 loop
        r:=r(14 downto 0)&'0';
        --rh:=r(15 downto 8);
        if(d<=r(15 downto 8)) then
            r(15 downto 8):=r(15 downto 8)-d;
            q:=q(6 downto 0)&'0';
            q:=q+"00000001";            
        else
            q:=q(6 downto 0)&'0';            
        end if;
    end loop X;
    
        if(dividend(7)='1' and divisor(7)='0') then
            c(7 downto 0):=q(7 downto 0);
            c(8):='0';
            c:="100000000"-c;
            q(7 downto 0):=c(7 downto 0);
            
            c(7 downto 0):=r(15 downto 8);
            c(8):='0';
            c:="100000000"-c;
            r(15 downto 8):=c(7 downto 0);
        elsif(dividend(7)='0' and divisor(7)='1') then
            c(7 downto 0):=q(7 downto 0);
            c(8):='0';
            c:="100000000"-c;
            q(7 downto 0):=c(7 downto 0);
        
        elsif(dividend(7)='1' and divisor(7)='1') then        
            c(7 downto 0):=r(15 downto 8);
            c(8):='0';
            c:="100000000"-c;
            r(15 downto 8):=c(7 downto 0);
        end if;
         input_invalid<='0';
         output_valid<='1';     
         qoutient<=q;
         remain<=r(15 downto 8);
    end if;
end process;

end behav;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab7_divider is
    port( divisor: in std_logic_vector(7 downto 0);
          dividend:in std_logic_vector(7 downto 0);
          output_valid:out std_logic;
          input_invalid:out std_logic;
          load_inputs:in std_logic;
          anode:out std_logic_vector(3 downto 0);
          cathode:out std_logic_vector(6 downto 0);
          clk:in std_logic;
          sim_mode:in std_logic
        );
end lab7_divider;

architecture Behavioral of lab7_divider is
    signal q,rh:std_logic_vector(7 downto 0);
begin
    A: entity work.divider(behav)
       port map(divisor,dividend,output_valid,input_invalid,load_inputs,q,rh);
    B: entity work.seven_segment(behav)
       port map(q(7 downto 4),q(3 downto 0),rh(7 downto 4),rh(3 downto 0),clk,anode,cathode);
end Behavioral;
