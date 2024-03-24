/********************************************************************************** 
TestBench SystemVerilog pour un UART verilog

Cours INF8500 Spécification et conception des systèmes embarqués
Responsable: Guy Bois
Chargé de labs: Fabien Portas

Référence: Le langage SystemVerilog de S. Moutault et J. Weber chez Dunod
***********************************************************************************/

// Programme principal du TestBench
program test_uart #(time Tck = 20000ps) (if_to_Uart bfm, if_to_Uart reference_if);
   import uart_test_classes::*;
   Uart_driver uart_driver ;
   Uart_receiver uart_receiver ;
   Uart_write uart_write ;
   Uart_check uart_check ;
   Uart_config uart_config;
   Uart_cover_group  uart_cover_group;
   Config conf;
   
   // Nombre de message a envoye et recevoir par test de transmission
   int nb_msg = 10;

   int n = 0;
   
   // Mailbox Uart_Write (Generateur) vers Uart_Driver
   mailbox send_data_vers_driver = new();
   mailbox recept_data_vers_driver = new();
   
   // Mailbox Uart_receiver vers Uart_Check (Scoreboard)
   mailbox receiver_sent_test = new(); // DUT vers Receiver(test de reception du DUT)
   mailbox receiver_recept_test = new(); // DUT vers Receiver (test d'evoi du DUT)
   
   // Mailbox Uart_driver vers Uart_Check (Scoreboard)
   mailbox driver_sent_test = new(); // Driver vers DUT (test d'envoi du DUT)
   mailbox driver_recept_test = new(); // Driver vers DUT (test de reception du DUT)
   
   //Mailbox du driver vers le module rxtx pour indiquer l'erreur à injecter à la prochaine transmision
   mailbox err_rxtx = new();
   mailbox err_check = new();

   
  
   initial begin

      uart_cover_group = new();
      
      uart_driver = new(bfm, reference_if, send_data_vers_driver, nb_msg, recept_data_vers_driver, nb_msg,
                    driver_sent_test, driver_recept_test, err_rxtx, err_check, uart_cover_group );
                    
      uart_receiver = new(bfm, reference_if, receiver_sent_test, receiver_recept_test, uart_cover_group); 
      
      uart_write = new(send_data_vers_driver, nb_msg, recept_data_vers_driver, nb_msg  );
      
      uart_check = new(driver_sent_test, nb_msg, receiver_sent_test,
                        driver_recept_test, nb_msg, receiver_recept_test, err_check );
	   
	  
	  
      conf = new;
      conf.randomize();
      uart_config = new(conf.baudrate, conf.parite, uart_cover_group);
      
      
      // Test avec configuration aleatoire
      while($get_coverage() < 100) begin
        n = n+1;
        uart_driver.init_uart(uart_config,Tck);
        uart_driver.init_Error_inj(conf);
        uart_receiver.init_uart(uart_config,Tck);

        uart_config.Report();
      
         fork : test_simple
           uart_write.run();
           uart_driver.run();
           uart_receiver.run();
           uart_check.run();
         join_any
         disable test_simple;
            
        $display("Test terminé à %t",$time);
        //On doit ré-initialiser les drivers
        uart_driver.reset();
        uart_receiver.reset();
        conf.randomize();
        uart_driver.init_Error_inj(conf);
        uart_config.set(conf.baudrate, conf.parite);
		
      end //repeat

     $display("%0d", n);
       $display("simulation terminée à %t",$time);
       uart_check.bilan();
       uart_cover_group.stats;
      
      
      $finish();
   end //initial
   
   final begin
      uart_check.bilan();
   end //final      
   
endprogram : test_uart
