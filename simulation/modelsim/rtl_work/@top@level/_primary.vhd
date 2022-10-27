library verilog;
use verilog.vl_types.all;
entity TopLevel is
    port(
        SW              : in     vl_logic_vector(17 downto 0);
        KEY             : in     vl_logic_vector(3 downto 0);
        CLOCK_27        : in     vl_logic;
        LEDR            : out    vl_logic_vector(17 downto 0);
        LEDG            : out    vl_logic_vector(8 downto 0);
        DRAM_ADDR       : out    vl_logic_vector(11 downto 0);
        DRAM_CLK        : out    vl_logic;
        DRAM_BA_1       : out    vl_logic;
        DRAM_BA_0       : out    vl_logic;
        DRAM_LDQM       : out    vl_logic;
        DRAM_UDQM       : out    vl_logic;
        DRAM_CKE        : out    vl_logic;
        DRAM_CS_N       : out    vl_logic;
        DRAM_RAS_N      : out    vl_logic;
        DRAM_CAS_N      : out    vl_logic;
        DRAM_WE_N       : out    vl_logic;
        DRAM_DQ         : inout  vl_logic_vector(15 downto 0)
    );
end TopLevel;
