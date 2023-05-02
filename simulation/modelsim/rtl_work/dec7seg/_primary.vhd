library verilog;
use verilog.vl_types.all;
entity dec7seg is
    port(
        ent             : in     vl_logic_vector(3 downto 0);
        leds            : out    vl_logic_vector(7 downto 0)
    );
end dec7seg;
