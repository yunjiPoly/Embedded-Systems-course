if [file exists work] {
  vdel -lib ./work -all
}
echo "###"
echo "### Creating library and compiling design ..."
echo "###"
vlib work
# Compilation des fichiers sources
# Compilation du UART
vlog -mfcu -sv module_uart/*.sv
#Compilation du TB
vlog -mfcu -sv if_to_uart.sv pkg_uart_test_classes.sv test_uart.sv top_uart_with.sv uart_tb.sv
#vopt +acc=sa work.uart_tb -o dbgver
#vsim -t ps -voptargs="+acc" -assertdebug dbgver
# Configuration de la fenêtre de visualisation des traces
vsim -t ps work.uart_tb
add wave {sim:/uart_tb/bfm/we } 
add wave {sim:/uart_tb/bfm/ce } 
add wave {sim:/uart_tb/bfm/adr } 
add wave {sim:/uart_tb/bfm/dat } 
add wave {sim:/uart_tb/bfm/rx } 
add wave {sim:/uart_tb/bfm/tx } 
add wave {sim:/uart_tb/bfm/arst } 
add wave {sim:/uart_tb/bfm/inter } 
add wave {sim:/uart_tb/stimuli/bfm/cb/inter } 
add wave {sim:/uart_tb/bfm/arst } 
add wave {sim:/uart_tb/reference/we } 
add wave {sim:/uart_tb/reference/ce } 
add wave {sim:/uart_tb/reference/adr } 
add wave {sim:/uart_tb/reference/dat } 
add wave {sim:/uart_tb/reference/rx } 
add wave {sim:/uart_tb/reference/tx } 
add wave {sim:/uart_tb/reference/arst } 
add wave {sim:/uart_tb/reference/inter } 
add wave {sim:/uart_tb/reference/arst } 
run -all
coverage report -detail -cvg -file report.txt

