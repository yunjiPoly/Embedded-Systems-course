/********************************************************************************** 
TestBench SystemVerilog pour un UART verilog

Cours INF8500 Spécification et conception des systèmes embarqués
Responsable: Guy Bois
Chargé de labs: Fabien Portas

Référence: Le langage SystemVerilog de S. Moutault et J. Weber chez Dunod
***********************************************************************************/

// Module top recepteur uart (DUT)
// Est interfacé avec le testbench via l'interface

module top_Uart(if_to_Uart bfm) ;
   uartDevice dut_phys ( 
               .clk(bfm.clk), 
               .arst(bfm.arst), 
               .we(bfm.we), 
               .ce(bfm.ce),
               .adr(bfm.adr),
               .dat(bfm.dat),
               .rx(bfm.rx),
               .tx(bfm.tx),
               .inter(bfm.inter),
               .dis_int(bfm.dis_int) ) ;
endmodule : top_Uart