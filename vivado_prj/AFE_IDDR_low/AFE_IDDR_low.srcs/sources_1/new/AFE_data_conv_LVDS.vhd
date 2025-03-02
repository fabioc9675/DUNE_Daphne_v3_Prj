----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Fabian Castano
-- 
-- Create Date: 01.03.2025 23:46:58
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.ALL;


entity AFE_data_conv_LVDS is
    Port (
             fclk_p                   : in  std_logic;
             fclk_n                   : in  std_logic; 
             rst                      : in  std_logic; 
             data_p                   : in  std_logic;
             data_n                    : in  std_logic;
             fclk_out                 : out std_logic;
             data_Lsb_out             : out std_logic_vector(15 downto 0);
             data_Msb_out             : out std_logic_vector(15 downto 0)
         );
end AFE_data_conv_LVDS;

architecture Behavioral of AFE_data_conv_LVDS is


    component iddr_clk_gen is
      Port (
            FCLK                      : in  std_logic;
            RST                       : in  std_logic; 
            DATA_CLKP                 : out std_logic
            );
    end component;
    
    component iddr_data_fifo is
      Port ( DCLK_PBufg               : in  std_logic;
             RST                      : in  std_logic;
             Data                     : in  std_logic;
             QLSB_Out                 : out std_logic_vector(13 downto 0);
             QMSB_Out                 : out std_logic_vector(13 downto 0)
        );
    end component;
    
    signal DCLK                       : std_logic;
    signal FCLK_QLSB_Out_in           : std_logic_vector(13 downto 0);
    signal FCLK_QMSB_Out_in           : std_logic_vector(13 downto 0);
    signal DCLK_QLSB_Out_in           : std_logic_vector(13 downto 0);
    signal DCLK_QMSB_Out_in           : std_logic_vector(13 downto 0);
    signal FCLK                       : std_logic;
    signal DATA                       : std_logic;

begin

    -- IBUFDS: Differential Input Buffer
    --         Artix-7
    -- Xilinx HDL Language Template, version 2022.2

    IBUFDS_fclk : IBUFDS
    generic map (
        DIFF_TERM => FALSE, -- Differential Termination 
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DIFF_HSTL_I_18")
    port map (
        O  => FCLK,  -- Buffer output
        I  => fclk_p,  -- Diff_p buffer input (connect directly to top-level port)
        IB => fclk_n --fclk_n -- Diff_n buffer input (connect directly to top-level port)
    );
    
    IBUFDS_data : IBUFDS
    generic map (
        DIFF_TERM => FALSE, -- Differential Termination 
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DIFF_HSTL_I_18")
    port map (
        O  => DATA,  -- Buffer output
        I  => data_p,  -- Diff_p buffer input (connect directly to top-level port)
        IB => data_n --data_n -- Diff_n buffer input (connect directly to top-level port)
    );


    clockG : iddr_clk_gen 
      Port map (
            FCLK             => FCLK,
            RST              => RST,  
            DATA_CLKP        => DCLK
            );
    
    FCLKD : iddr_data_fifo 
      Port map( 
             DCLK_PBufg            => DCLK,
             RST                   => RST,
             Data                  => FCLK,
             QLSB_Out              => FCLK_QLSB_Out_in,
             QMSB_Out              => FCLK_QMSB_out_in
        );
        
    dataCLKD : iddr_data_fifo 
      Port map( 
             DCLK_PBufg            => DCLK,
             RST                   => RST,
             Data                  => DATA,
             QLSB_Out              => DCLK_QLSB_Out_in,
             QMSB_Out              => DCLK_QMSB_out_in
        );    

    --sata_Msb_out <= DCLK_QMSB_out_in when FCLK_QMSB_out_in ="00000001111111";
    --sata_Lsb_out <= DCLK_QLSB_out_in when FCLK_QLSB_out_in = "11111110000000";
    
    process(dclk)
    begin
        if rising_edge(dclk) then
           if FCLK_QMSB_out_in ="00000001111111" then
              data_Msb_out <= "00" & DCLK_QMSB_out_in;
           end if;
           if FCLK_QLSB_out_in ="11111110000000" then
              data_Lsb_out <= "00" & DCLK_QLSB_out_in;
           end if;
        end if;
    end process;      
    
    fclk_out <= FCLK;

end Behavioral;
