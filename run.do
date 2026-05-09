# Create folder if needed
if {![file exists questa]} {
    file mkdir questa
}

# Create library in subfolder
if {![file exists questa/work]} {
    vlib questa/work
}

# Map logical "work" to that folder
vmap work questa/work

# Compile & run
vlog src/dsp_fir.v
vlog src/SPISlave.v
vlog test/tb_dsp_fir.v
vsim work.tb_dsp_fir -voptargs=+acc
add wave -r *
run -all