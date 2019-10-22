set_global_assignment -entity "ddrclk" -library "lib_ddrclk" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "ddrclk" -library "lib_ddrclk" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "ddrclk" -library "lib_ddrclk" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ddrclk" -name SPD_FILE [file join $::quartus(sip_path) "ddrclk.spd"]

set_global_assignment -library "lib_ddrclk" -name MISC_FILE [file join $::quartus(sip_path) "ddrclk_sim/ddrclk.vhd"]
set_global_assignment -library "lib_ddrclk" -name MISC_FILE [file join $::quartus(sip_path) "ddrclk_sim/altera_gpio_lite/altera_gpio_lite.sv"]
set_global_assignment -library "lib_ddrclk" -name MISC_FILE [file join $::quartus(sip_path) "ddrclk_sim/altera_gpio_lite/mentor/altera_gpio_lite.sv"]
