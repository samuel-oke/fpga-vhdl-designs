library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Generic register (cleaned)
entity reg_generic is
  generic (
    BIT_WIDTH : integer := 10
  );
  port (
    clk : in  std_logic;
    rst : in  std_logic;  -- asynchronous, active-high
    wen : in  std_logic;  -- write enable, active-high
    d   : in  std_logic_vector(BIT_WIDTH-1 downto 0);
    q   : out std_logic_vector(BIT_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of reg_generic is
  signal r : std_logic_vector(BIT_WIDTH-1 downto 0);
begin
  q <= r;

  process(clk, rst)
  begin
    if rst = '1' then
      r <= (others => '0');
    elsif rising_edge(clk) then
      if wen = '1' then
        r <= d;
      end if;
    end if;
  end process;
end architecture;
