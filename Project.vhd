library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project_reti_logiche is
    port (
    i_clk : in std_logic;
    i_rst : in std_logic;   
    i_start : in std_logic;
    i_w : in std_logic;
    o_z0 : out std_logic_vector(7 downto 0);
    o_z1 : out std_logic_vector(7 downto 0);
    o_z2 : out std_logic_vector(7 downto 0);
    o_z3 : out std_logic_vector(7 downto 0);
    o_done : out std_logic;
    o_mem_addr : out std_logic_vector(15 downto 0);
    i_mem_data : in std_logic_vector(7 downto 0);
    o_mem_we : out std_logic;
    o_mem_en : out std_logic
    );
end project_reti_logiche;

architecture Structural of project_reti_logiche is

component datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_rst_reg : in  std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        r2_load : in std_logic;
        r3_load : in std_logic;
        print : in std_logic;
        helper : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_addr : out std_logic_vector(15 downto 0);
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0)   
    );
end component;

component fsm is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        print : out std_logic;
        helper : out std_logic;
        i_rst_reg : out std_logic;  
        r2_load : out std_logic;
        r3_load : out std_logic;
        o_done : out std_logic;
        o_mem_en : out std_logic;
        o_mem_we : out std_logic
    );
end component;

signal helper : std_logic;
signal r2_load : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal i_rst_reg: STD_LOGIC;
signal print : STD_LOGIC;

begin
    DATAPATH0 : datapath port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_rst_reg => i_rst_reg,
        i_start => i_start,
        i_w => i_w,
        print => print,
        helper=>helper,
        i_mem_data => i_mem_data,
        o_mem_addr => o_mem_addr,
        r3_load => r3_load,
        r2_load => r2_load,
        o_z0 => o_z0,
        o_z1 => o_z1,
        o_z2 => o_z2,
        o_z3 => o_z3
    );

    FSM0 : fsm port map(
        i_clk=>i_clk,
        i_rst=>i_rst,
        i_start=>i_start,
        print=>print,
        helper=>helper,
        i_rst_reg=>i_rst_reg,
        r2_load=>r2_load,
        r3_load=>r3_load,
        o_done=>o_done,
        o_mem_en=>o_mem_en,
        o_mem_we=>o_mem_we
    );

end Structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        print : out std_logic;
        helper : out std_logic;
        i_rst_reg : out std_logic;  
        r2_load : out std_logic;
        r3_load : out std_logic;
        o_done : out std_logic;
        o_mem_en : out std_logic;
        o_mem_we : out std_logic
    );
end fsm;

architecture Behavioral of fsm is

type S is (S0,S1,S2,S3,S4,S5);
signal curr_state, next_state : S;

begin
    process(i_clk,i_rst)
    begin
        if i_rst='1' then
            curr_state<=S0;
        elsif i_clk'event and i_clk='1' then
            curr_state<=next_state;
        end if;
    end process;
    
    process(curr_state,i_start)
    begin
        next_state<=curr_state;
        case curr_state is
            when S0=>
                if i_start='0' then
                    next_state<=curr_state;
                else
                    next_state<=S1;
                end if ;
            when S1=>
                next_state<=S2;
            when S2=>
                if i_start='1' then
                    next_state<=curr_state;
                else
                    next_state<=S3;
                end if ;
            when S3=>
                next_state<=S4;
            when s4=>
                next_state<=S5;
            when S5=>
                next_state<=S0;
        end case;
    end process;

    process(curr_state)
    begin
        i_rst_reg<='0';
        r2_load<='0';
        r3_load<='0';
        o_mem_en<='0';
        o_mem_we<='0';
        print<='0';
        helper<='0';
        o_done<='0';
        case curr_state is
            when S0=>
                i_rst_reg<='1';
                r2_load<='1';
            when S1=>
                r2_load<='1';
            when S2=>
                r3_load<='1';
            when S3=>
                o_mem_en<='1';
            when S4=>
                print<='1';
            when S5=>
                helper<='1';
                o_done<='1';
        end case;
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_rst_reg : in std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        r2_load : in std_logic;
        r3_load : in std_logic;
        print : in std_logic;
        helper : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_addr : out std_logic_vector(15 downto 0);
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0)   
    );
end datapath;

architecture Structural of datapath is

component reg2 is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_rst_reg : in std_logic;
        r2_load : in std_logic;
        i_w : in std_logic;
        o_reg_2 : out std_logic_vector( 1 downto 0)
    );
end component;

component reg3 is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_rst_reg : in std_logic;
        r3_load : in std_logic;
        i_w : in std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0)
    );
end component;

component o_demux is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        o_reg_2 : in std_logic_vector(1 downto 0);
        i_start : in std_logic;
        print : in std_logic;
        i_z0 : out std_logic_vector(7 downto 0);
        i_z1 : out std_logic_vector(7 downto 0);
        i_z2 : out std_logic_vector(7 downto 0);
        i_z3 : out std_logic_vector(7 downto 0)
    );
end component;

component o_reg0 is
    port(
        i_z0:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper:in std_logic;
        o_z0:out std_logic_vector(7 downto 0)
    );
end component;

component o_reg1 is
    port(
        i_z1:in std_logic_vector(7 downto 0);
        helper: in std_logic;
        i_clk:in std_logic;
        o_z1:out std_logic_vector(7 downto 0)
    );
end component;

component o_reg2 is
    port(
        i_z2:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper : in std_logic;
        o_z2:out std_logic_vector(7 downto 0)
    );
end component;

component o_reg3 is
    port(
        i_z3:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper:in std_logic;
        o_z3:out std_logic_vector(7 downto 0)
    );
end component;


signal o_reg_2 : std_logic_vector(1 downto 0);
signal i_z0 : std_logic_vector(7 downto 0);
signal i_z1 : std_logic_vector(7 downto 0);
signal i_z2 : std_logic_vector(7 downto 0);
signal i_z3 : std_logic_vector(7 downto 0);

begin

    REG2_0 : reg2 port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_rst_reg => i_rst_reg,
        r2_load => r2_load,
        i_w => i_w,
        o_reg_2 => o_reg_2
    );
    REG3_0 : reg3 port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_start=>i_start,
        i_rst_reg => i_rst_reg,
        r3_load => r3_load,
        i_w => i_w,
        o_mem_addr => o_mem_addr
    );
    O_DEMUX0 : o_demux port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_mem_data => i_mem_data,
        o_reg_2 => o_reg_2,
        print=>print,
        i_start => i_start,
        i_z0 => i_z0,
        i_z1 => i_z1,
        i_z2 => i_z2,   
        i_z3 => i_z3
    );
    OREG0 : o_reg0 port map(
        i_z0=>i_z0,
        i_clk=>i_clk,
        helper=>helper,
        o_z0=>o_z0
    );
    OREG1 : o_reg1 port map(
        i_z1=>i_z1,
        helper=>helper,
        i_clk=>i_clk,
        o_z1=>o_z1
    );
    OREG2 : o_reg2 port map(
        i_z2=>i_z2,
        i_clk=>i_clk,
        helper=>helper,
        o_z2=>o_z2
    );
    OREG3 : o_reg3 port map(
        i_z3=>i_z3,
        i_clk=>i_clk,
        helper=>helper,
        o_z3=>o_z3
    );

end Structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg2 is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_rst_reg : in std_logic;
        r2_load : in std_logic;
        i_w : in std_logic;
        o_reg_2 : out std_logic_vector(1 downto 0)
    );
end reg2;

architecture Behavioral of reg2 is

signal tmp : std_logic_vector(1 downto 0);
    
begin
    process(i_rst,i_clk,i_rst_reg,r2_load)
    begin
        if i_rst = '1' then
            tmp <= "00";
        elsif i_clk'event and i_clk = '1' and r2_load = '1' then 
            tmp<=tmp(0)&i_w;            
        end if;
        o_reg_2 <= tmp;  
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg3 is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_rst_reg : in std_logic;
        i_start : in std_logic;
        r3_load : in std_logic;
        i_w : in std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0)
    );
end reg3;

architecture Behavioral of reg3 is

signal tmp : std_logic_vector(15 downto 0);
    
begin
    process(i_rst,i_clk,i_rst_reg,r3_load)
    begin
        if i_rst = '1' or i_rst_reg = '1' then
        tmp <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' and r3_load = '1' and i_start ='1' then
            tmp(15)<=tmp(14); 
            tmp(14)<=tmp(13);
            tmp(13)<=tmp(12);
            tmp(12)<=tmp(11);
            tmp(11)<=tmp(10);
            tmp(10)<=tmp(9);
            tmp(9)<=tmp(8);
            tmp(8)<=tmp(7);
            tmp(7)<=tmp(6);
            tmp(6)<=tmp(5);
            tmp(5)<=tmp(4);
            tmp(4)<=tmp(3);
            tmp(3)<=tmp(2);
            tmp(2)<=tmp(1);
            tmp(1)<=tmp(0);
            tmp(0)<=i_w;
        end if;
        o_mem_addr <= tmp;
    end process;
    
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity o_demux is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        print : in std_logic;
        o_reg_2 : in std_logic_vector(1 downto 0);
        i_start : in std_logic;
        i_z0 : out std_logic_vector(7 downto 0);
        i_z1 : out std_logic_vector(7 downto 0);
        i_z2 : out std_logic_vector(7 downto 0);
        i_z3 : out std_logic_vector(7 downto 0)
    );
end o_demux;

architecture Behavioral of o_demux is

begin
    process(i_rst,i_clk)
    begin
        if i_rst = '1' then
            i_z0 <= "00000000";
            i_z1 <= "00000000";
            i_z2 <= "00000000";
            i_z3 <= "00000000";  
        elsif i_clk'event and i_clk='1' then
            if i_start = '0' and print = '1' then
                if o_reg_2 = "00" then
                    i_z0 <= i_mem_data;
                elsif o_reg_2 = "01" then
                    i_z1 <= i_mem_data;
                elsif o_reg_2 = "10" then
                    i_z2 <= i_mem_data;
                elsif o_reg_2 = "11" then
                    i_z3 <= i_mem_data;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity o_reg0 is
    port(
        i_z0:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper:in std_logic;
        o_z0:out std_logic_vector(7 downto 0)
    );
end o_reg0;

architecture Behavioral of o_reg0 is
    
begin
    process(i_clk,helper)
    begin
        if helper = '1' then
            o_z0 <= i_z0;
        else
            o_z0<="00000000";
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity o_reg1 is
    port(
        i_z1:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper : in std_logic;
        o_z1:out std_logic_vector(7 downto 0)
    );
end o_reg1;

architecture Behavioral of o_reg1 is
    
begin
    process(i_clk,helper)
    begin
        if helper = '1' then
            o_z1 <= i_z1;
        else
            o_z1<="00000000";
        end if;
    end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity o_reg2 is
    port(
        i_z2:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper : in std_logic;
        o_z2:out std_logic_vector(7 downto 0)
    );
end o_reg2;

architecture Behavioral of o_reg2 is
    
begin
    process(i_clk,helper)
    begin
        if helper = '1' then
            o_z2 <= i_z2;
        else
            o_z2<="00000000";
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity o_reg3 is
    port(
        i_z3:in std_logic_vector(7 downto 0);
        i_clk:in std_logic;
        helper:in std_logic;
        o_z3:out std_logic_vector(7 downto 0)
    );
end o_reg3;

architecture Behavioral of o_reg3 is

begin
    process(i_clk,helper)
    begin
        if helper = '1' then
            o_z3 <= i_z3;
        else
            o_z3<="00000000";
        end if;
    end process;
end Behavioral;