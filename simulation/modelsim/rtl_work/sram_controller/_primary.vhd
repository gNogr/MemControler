library verilog;
use verilog.vl_types.all;
entity sram_controller is
    generic(
        W_B_Length      : vl_logic := Hi1;
        Test_mode       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        CAS_Latency     : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Burst_length    : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Wrap_type       : vl_logic := Hi0;
        RASCAS_time     : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        az_cs           : in     vl_logic;
        az_rd_n         : in     vl_logic;
        az_wr_n         : in     vl_logic;
        az_be_n         : in     vl_logic_vector(1 downto 0);
        az_addr         : in     vl_logic_vector(21 downto 0);
        az_data         : in     vl_logic_vector(15 downto 0);
        za_valid        : out    vl_logic;
        za_wait         : out    vl_logic;
        za_data         : out    vl_logic_vector(15 downto 0);
        zs_addr         : out    vl_logic_vector(11 downto 0);
        zs_ba           : out    vl_logic_vector(1 downto 0);
        zs_dqm          : out    vl_logic_vector(1 downto 0);
        zs_cke          : out    vl_logic;
        zs_cs_n         : out    vl_logic;
        zs_ras_n        : out    vl_logic;
        zs_cas_n        : out    vl_logic;
        zs_we_n         : out    vl_logic;
        zs_dq           : inout  vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W_B_Length : constant is 1;
    attribute mti_svvh_generic_type of Test_mode : constant is 1;
    attribute mti_svvh_generic_type of CAS_Latency : constant is 1;
    attribute mti_svvh_generic_type of Burst_length : constant is 1;
    attribute mti_svvh_generic_type of Wrap_type : constant is 1;
    attribute mti_svvh_generic_type of RASCAS_time : constant is 1;
end sram_controller;
