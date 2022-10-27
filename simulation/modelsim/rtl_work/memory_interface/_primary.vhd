library verilog;
use verilog.vl_types.all;
entity memory_interface is
    port(
        command         : in     vl_logic_vector(3 downto 0);
        mrs             : in     vl_logic_vector(11 downto 0);
        addr_in         : in     vl_logic_vector(21 downto 0);
        be_in           : in     vl_logic_vector(1 downto 0);
        addr_out        : out    vl_logic_vector(11 downto 0);
        ba_out          : out    vl_logic_vector(1 downto 0);
        dqm             : out    vl_logic_vector(1 downto 0);
        cke             : out    vl_logic;
        cs_n            : out    vl_logic;
        ras_n           : out    vl_logic;
        cas_n           : out    vl_logic;
        we_n            : out    vl_logic
    );
end memory_interface;
