/********************************************************************************** 
TestBench SystemVerilog pour un UART verilog

Cours INF8500 Spécification et conception des systèmes embarqués
Responsable: Guy Bois
Chargé de labs: Fabien Portas

Référence: Le langage SystemVerilog de S. Moutault et J. Weber chez Dunod
***********************************************************************************/

// Assemblage de tout le système: interface, DUT et Testbench
module uart_tb;
   parameter time Tck = 20000ps;
   bit clk; // le type bit evite de creer un evenement a t=0
   if_to_Uart bfm(clk);     // interface   
   top_Uart mut(bfm); 		// module testé i.e. DUT
   if_to_Uart reference(clk); //interface pour uart reference
   top_Uart uart_reference(reference); //uart de référence, on suppose que ce UART est un système commercial et donc testé
   test_uart #(Tck) stimuli(bfm, reference); // programme de test   
   initial forever #(Tck/2) clk = ~clk;
endmodule : uart_tb
