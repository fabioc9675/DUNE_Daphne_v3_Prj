##################### PL I2C Interface ################################
set_property PACKAGE_PIN AD10 [get_ports {pl_i2c_sda_io}]     
set_property IOSTANDARD LVCMOS33 [get_ports {pl_i2c_sda_io}] 
set_property PULLUP TRUE [get_ports {pl_i2c_sda_io}]

set_property PACKAGE_PIN AD11 [get_ports {pl_i2c_scl_io}]
set_property IOSTANDARD LVCMOS33 [get_ports {pl_i2c_scl_io}]
set_property PULLUP TRUE [get_ports {pl_i2c_scl_io}]

