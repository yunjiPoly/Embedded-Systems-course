/********************************************************************************** 
TestBench SystemVerilog pour un UART verilog

Cours INF8500 Spécification et conception des systèmes embarqués
Responsable: Guy Bois
Chargé de labs: Fabien Portas


Référence: Le langage SystemVerilog de S. Moutault et J. Weber chez Dunod
***********************************************************************************/

// Contient les blocs constituant le TestBench
package uart_test_classes;

typedef enum {noError = 0, pError = 1, dError = 3} Error_type;
//noError = pas d erreur injectée
//pError = erreur sur le bit de parité
//dError = erreur sur les données

typedef enum {br_9600=9600, br_19200=19200, br_115200=115200, br_153600=153600, br_921600=921600} Valid_baudrate;
typedef enum {NONE=0, EVEN=1, ODD=3} Parity;
int err_num = 0; // comptage des erreurs

int unsigned PARITY_EN = 8;
int unsigned PARITY_EVEN = 16;

semaphore sem_dut = new(1);
semaphore sem_ref = new(1);

class Uart_cover_group;

static logic  [7:0] dut_status, ref_status;
Valid_baudrate baudrate;
Parity parite;
Error_type err_inject_tx;

covergroup cg;

  // MODIFICATIONS A PARTIR D'ICI

  coverpoint baudrate {  
    // A compléter
    bins bin_br_9600 = {br_9600};  
    bins bin_br_19200 = {br_19200};  
    bins bin_br_115200 = {br_115200};  
    bins bin_br_153600 = {br_153600};  
    bins bin_br_921600 = {br_921600};  
    bins others	= default;
  }

  coverpoint parite {
    // A compléter
    bins bin_NONE = {NONE};
    bins bin_EVEN = {EVEN};
    bins bin_ODD = {ODD};
  }

  coverpoint dut_status {
    // Exemple pour monitorer uniquement le bit 0 du registre de status du DUT (dut_status). Le point est couvert si le bit de poids fauble du dut_status passe à 1.
    // Cet exemple est à modifier
    wildcard bins bin_rx_success = {8'b????0001};
    wildcard bins bin_tx_success = {8'b??1?000?};
    wildcard bins bin_parite_error = {8'b?????1??};
  }
  
  coverpoint ref_status {
    // A compléter
    wildcard bins bin_tx_success = {8'b??1?000?};
    wildcard bins bin_rx_success = {8'b????0001};
    
  } 

  coverpoint err_inject_tx {
    bins bin_noError = {noError};
    bins bin_pError = {pError};
    bins bin_dError = {dError};
  }      

  cross baudrate, parite, dut_status, ref_status, err_inject_tx  {
    // Désactiver cross automatique
    option.cross_auto_bin_max = 0;

    // Baudrate no error
    bins c01 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c02 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c03 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c04 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c05 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);

    // Parite odd avec error parite
    bins c06 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c07 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c08 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c09 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c10 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);

    // Parite odd avec error donnees
    bins c11 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c12 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c13 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c14 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c15 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);

    // Parite odd sans error
    bins c16 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c17 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c18 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_ODD) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c19 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c20 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_ODD) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);

    // Parite even avec error parite
    bins c21 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c22 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c23 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c24 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);
    bins c25 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_pError);

    // Parite even avec error donnees
    bins c26 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c27 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c28 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c29 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c30 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_parite_error) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);

    // Parite even sans error
    bins c31 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c32 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c33 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c34 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);
    bins c35 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_EVEN) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_noError);

    // Sans parite avec injection error 
    bins c36 = binsof(baudrate.bin_br_9600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c37 = binsof(baudrate.bin_br_19200) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c38 = binsof(baudrate.bin_br_115200) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c39 = binsof(baudrate.bin_br_153600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);
    bins c40 = binsof(baudrate.bin_br_921600) && binsof(parite.bin_NONE) && binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_tx_success) && binsof(err_inject_tx.bin_dError);

    // rx - rx
    bins c41 = binsof(dut_status.bin_rx_success) && binsof(ref_status.bin_rx_success);

    // tx - tx
    bins c42 = binsof(dut_status.bin_tx_success) && binsof(ref_status.bin_tx_success);


}

endgroup
// NE PAS MODIFIER LA SUITE

  function void set_config(Valid_baudrate baudrate, Parity parite);
    this.parite = parite;
    this.baudrate = baudrate;
	cg.sample;
  endfunction : set_config

  function void set_err_injection(Error_type err_inject_tx);
    this.err_inject_tx=err_inject_tx;
	cg.sample;
  endfunction : set_err_injection
  
  // Cette tâche peut vous être utile pour connaitre l'état de la couverture à tout instant...
  task stats;
         $display(" couverture :");   
         $display("status = %g ", cg.get_inst_coverage()); 
   endtask : stats
  
  task do_cover(logic  [7:0] dut_status, ref_status);
    this.dut_status = dut_status;
	this.ref_status = ref_status;
	cg.sample;
  endtask
  
  function new();
	cg = new;
  endfunction : new
  
endclass : Uart_cover_group;

class Config;
  randc Valid_baudrate baudrate;
  rand Parity parite;
endclass : Config

class InjectionErrType;
  Config configuration;
  rand Error_type tx_err_injection;
  rand int data_bit_to_change;
  
  function void init(Config configuration);
    this.configuration = configuration;
  endfunction : init
  
  constraint err_injection { 
    if (this.configuration.parite == NONE)
      tx_err_injection != pError;				
    
    data_bit_to_change inside { [1 : 8] };
  }
endclass : InjectionErrType


class Uart_config;
  //Class de configuration des modules 
  Valid_baudrate baudrate;
  Parity parite;
  Uart_cover_group uart_cover_group;
  
  function new(Valid_baudrate baudrate, Parity parite, Uart_cover_group uart_cover_group);
    this.parite = parite;
    this.baudrate = baudrate;
	this.uart_cover_group = uart_cover_group;
	uart_cover_group.set_config(baudrate, parite);
  endfunction : new
    
  function void set(Valid_baudrate baudrate, Parity parite);
    this.parite = parite;
    this.baudrate = baudrate;
	uart_cover_group.set_config(baudrate, parite);
  endfunction : set
  
  function int int_baudrate();
    case (this.baudrate)
      br_9600 : int_baudrate   = 9600;
      br_19200 : int_baudrate  = 19200;
      br_115200 : int_baudrate = 115200;
      br_153600 : int_baudrate = 153600;
      br_921600 : int_baudrate = 921600;
    endcase
  endfunction : int_baudrate
  
  function time get_bd_ticks();
    case (this.baudrate)
      br_9600 : get_bd_ticks   = 104160000ps;
      br_19200 : get_bd_ticks  = 52160000ps;
      br_115200 : get_bd_ticks = 8640000ps;
      br_153600 : get_bd_ticks = 6560000ps;
      br_921600 : get_bd_ticks = 1120000ps;
    endcase
  endfunction : get_bd_ticks
  
  function bit[7:0] Control();
    Control = 3; //initialement, tx et rx sont activés
    if ( this.parite == EVEN )
      Control |= PARITY_EN | PARITY_EVEN;
    else if (this.parite == ODD)
      Control |= PARITY_EN;
  endfunction : Control;
  
  task Report();
    $display("\nConfig report\n");
    $display("Baudrate : %d",int_baudrate());
    case (this.parite)
      NONE : $display("Parity : NONE");
      EVEN : $display("Parity : EVEN");
      ODD  : $display("Parity : ODD");
    endcase 
  endtask : Report 

endclass  : Uart_config
  
// Traitement des signaux du côté série
class Uart_rxtx;
   local virtual if_to_Uart dut_uart;
   local virtual if_to_Uart reference_uart;
   time divisor = 20000ps;
   Uart_config uart_config;
   Error_type err;
   mailbox err_rxtx;
   int data_bit_to_change = 0;
   
   function new(virtual if_to_Uart bfm, virtual if_to_Uart reference, mailbox err_rxtx);
      this.dut_uart = bfm;
      this.reference_uart = reference;
      this.err_rxtx = err_rxtx;
   endfunction : new
   
   function init(Uart_config uart_config );
    this.uart_config = uart_config;
 	  this.divisor = this.uart_config.get_bd_ticks();
 	  this.err = noError;
  endfunction : init
   
   function injectError(Error_type err, int data_bit_to_change);
    this.err = err;
    this.data_bit_to_change = data_bit_to_change;
   endfunction : injectError  
   
   task run();
     // Test pont entre les UART
     fork: pont
        uart_tx_to_dut_rx();
        dut_tx_to_uart_rx();
      join_any;
   endtask : run
   
   // Tache de pont vers la reception DUT
   // Implemente une machine a etat afin d'injecter des erreur aleatoires
   task uart_tx_to_dut_rx();
     bit output_tx_bit = 1;
       
     //$display("bit %b, Initial ", reference_uart.cb.tx);
     dut_uart.cb.rx <= output_tx_bit;
    
     forever begin
        err_rxtx.get(err);
        err_rxtx.get(data_bit_to_change);
        @(negedge reference_uart.cb.tx);
        
        dut_uart.cb.rx <= reference_uart.cb.tx;
        //$display("bit %b, Start ", reference_uart.cb.tx);
        
     
        for ( int count = 1; count <= 10 ; count++ ) begin
          #(this.divisor);
          
          output_tx_bit = reference_uart.cb.tx;
          
          case (this.err)
            
            pError : begin
                      // Parity error
                      if (count == 9) begin
                        //$display("bit %b, parite ", output_tx_bit);
                        output_tx_bit = ~output_tx_bit;
                      end
                    end
                   
                     
            dError : begin
                      // Data error
                        if ( count == this.data_bit_to_change ) begin
                          //$display("bit %b, data flip ", output_tx_bit);
                          output_tx_bit = ~output_tx_bit;
                        end
                     end
          endcase
           
          dut_uart.cb.rx <= output_tx_bit;
          
        end // for
        this.err = noError;
    end // forever
   endtask : uart_tx_to_dut_rx
   
   task dut_tx_to_uart_rx();
     forever begin
      @(dut_uart.cb); 
      reference_uart.cb.rx  <= dut_uart.cb.tx;
    end //forever
   endtask : dut_tx_to_uart_rx
   
endclass : Uart_rxtx
 

// Pilote du périphérique côté bus
class Uart_driver;
   time Tck = 20000ps;
   int nb_msg_send = 10;
   int nb_msg_receive = 10;
   local virtual if_to_Uart dut_uart;
   local virtual if_to_Uart reference_uart;
   static logic  [7:0] dut_status, ref_status, control;
   logic [7:0] dut_write_dat, ref_write_dat;
   Uart_cover_group uart_cover_group;
   Uart_config uart_cfg;
   Uart_rxtx uart_rxtx;
   InjectionErrType err_inject;
   mailbox send_data, recept_data, send_test, recept_test, err_rxtx, err_check;
   int nb_pError = 0;
   int nb_dError = 0;
   Error_type recorded_error = noError;
   

   function new(virtual if_to_Uart bfm, virtual if_to_Uart reference, 
                mailbox send_data, int nb_msg_send, mailbox recept_data, int nb_msg_receive, 
                mailbox driver_send_test, driver_recept_test, err_rxtx, err_check, 
				Uart_cover_group uart_cover_group);

	
    this.reference_uart = reference;
    this.dut_uart = bfm;
    this.send_data = send_data;
    nb_msg_send = nb_msg_send;
    this.recept_data = recept_data;
    nb_msg_receive = nb_msg_receive;
    this.send_test = driver_send_test;
    this.recept_test = driver_recept_test;
	this.uart_rxtx = new(bfm, reference, err_rxtx);
	this.err_inject = new;
	this.err_rxtx = err_rxtx;
	this.err_check = err_check;
	this.uart_cover_group = uart_cover_group;

	 endfunction : new
	 
	 task init_Error_inj (Config configuration);
	   this.err_inject.init(configuration);
	   endtask : init_Error_inj
   
   task reset();
     if (sem_dut.try_get()==0)
       sem_dut.put(1);
   endtask : reset
   
// calcule le prédiviseur (en fonction de la vitesse choisie 
// et de la fréquence d'horloge), réinitialise le
// périphérique et fixe le protocole choisi (control)
// ici : sans traitement d'erreurs
   task init_uart(Uart_config uart_config, time Tck);
   
	  bit[31:0] baud_rate;
      bit[7:0] control;
      automatic bit[15:0] diviseur;
	  
	  // sample config here
	  uart_cfg = uart_config;

      baud_rate = uart_cfg.int_baudrate();
      control = uart_cfg.Control(); 
           
      diviseur = 1e12/(8*baud_rate*Tck) - 1;
      // unite de temps ps => 1e12
      this.Tck = Tck;
      this.control = control;
	    this.uart_rxtx.init(uart_config);
      sem_dut.get(1);
      dut_uart.reset_if();
      dut_uart.write_if(2,diviseur & 8'hff); // baud rate LS
      dut_uart.write_if(3,diviseur >> 8); // baud rate MS
      dut_uart.write_if(1, control); 
      sem_dut.put(1);
      
   endtask : init_uart   
 
   task run();
      fork : uarts_interfaces
		     this.uart_rxtx.run();
         runDUT();
         runReference();
         runCheckError();
      join
   endtask : run 
   
   task runCheckError();
     forever begin
	reg[7:0] temp;
        err_check.get(temp);
	recorded_error = Error_type'(temp);
        case (recorded_error)
          pError : nb_pError = nb_pError + 1;
          dError : nb_dError = nb_dError + 1;
        endcase
      end
    endtask : runCheckError
   
   task runDUT();
   // Cette boucle traite en continu les interruptions
   // la synchronisation se fait sur le matériel (signal inter)
     int nb_msg = 0;
     forever begin
        sem_dut.get(1);
        dut_uart.wait_it();
        dut_uart.read_if(1,dut_status);

        
  // interruption en écriture : si des données sont prêtes 
  // elles sont envoyées, le test n'est pas bloquant 
        if( dut_status[5] == 1 && dut_status[0] == 0 && send_data.try_get(dut_write_dat) > 0 )begin  
		   uart_cover_group.do_cover(dut_status, ref_status);
           dut_uart.write_if(0,dut_write_dat);
           send_test.put(dut_write_dat);
           send_test.put(0);
           nb_msg++;
           end 
		   
// Traitement des erreurs de transmission
        if(dut_status[2] == 1) begin
           $display("à %t, Parity error ",$time);
           end
		   
		   
           sem_dut.put(1);
		        
		if ( nb_msg >= this.nb_msg_send ) break;
      end //forever
   endtask : runDUT 

   task runReference();
// Cette boucle traite en continu les interruptions
// la synchronisation se fait sur le matériel (signal inter)
     int nb_msg = 0;
     
     forever begin
        sem_ref.get(1);
        reference_uart.wait_it();
        reference_uart.read_if(1,ref_status);


// interruption en écriture : si des données sont prêtes 
// elles sont envoyées, le test n'est pas bloquant 
        if( ref_status[5] == 1 && ref_status[0] == 0 && recept_data.try_get(ref_write_dat) > 0 )begin
           
           // Generate random error injections
            err_inject.randomize();
			uart_cover_group.set_err_injection(err_inject.tx_err_injection);
			uart_cover_group.do_cover(dut_status, ref_status);
                        

           case (err_inject.tx_err_injection) 
             dError : $display("Reference : %d injection erreur donne", ref_write_dat);
             pError : $display("Reference : %d injection erreur parite", ref_write_dat);
           endcase
             
           err_rxtx.put(err_inject.tx_err_injection);
           err_rxtx.put(err_inject.data_bit_to_change);
           reference_uart.write_if(0,ref_write_dat);
           recept_test.put(ref_write_dat);
           recept_test.put(err_inject.tx_err_injection); //Notifier le check d'une 
           nb_msg++;
           end 
           
           sem_ref.put(1);
           
           if ( nb_msg >= this.nb_msg_receive ) break;
      end //forever
   endtask : runReference 
   

endclass : Uart_driver
   
class Uart_receiver;
   time Tck = 20000ps;
   local virtual if_to_Uart dut_uart, reference_uart;
   static logic  [7:0] dut_status, ref_status, control;
   logic [7:0] ref_read_dat, dut_read_dat;
   mailbox send_test, recept_test;
   Uart_cover_group uart_cover_group;
 
 
   function new(virtual if_to_Uart bfm, reference,
                mailbox receiver_send_test, receiver_recept_test,
		Uart_cover_group uart_cover_group); 
				
      this.dut_uart = bfm;
      this.reference_uart = reference;
      this.send_test = receiver_send_test;
      this.recept_test = receiver_recept_test;
	  this.uart_cover_group = uart_cover_group; 
   endfunction : new
   
   // on doit débloquer le sémaphore si le test interrompu
   task reset();
     if (sem_ref.try_get()==0)
       sem_ref.put(1);
   endtask : reset
   
// calcule le prédiviseur (en fonction de la vitesse choisie 
// et de la fréquence d'horloge), réinitialise le
// périphérique et fixe le protocole choisi (control)
// ici : sans traitement d'erreurs
   task init_uart(Uart_config uart_config, time Tck);
      bit[31:0] baud_rate = uart_config.int_baudrate();
      automatic bit[15:0] diviseur;
      
      this.Tck = Tck;
      this.control = uart_config.Control();
      
      diviseur = 1e12/(8*baud_rate*Tck) - 1;
      
      sem_ref.get(1);
      reference_uart.reset_if();
      reference_uart.write_if(2,diviseur & 8'hff); // baud rate LS
      reference_uart.write_if(3,diviseur >> 8); // baud rate MS
      reference_uart.write_if(1, control);
      sem_ref.put(1);
   endtask : init_uart   
 
   task run();
      fork : uarts_interfaces
         runDUT();
         runReference();
      join_any
   endtask : run 
   
   task runReference();
// Cette boucle traite en continu les interruptions du Uart de reference (test d'envoi)
// la synchronisation se fait sur le matériel (signal inter)
     forever begin
        sem_ref.get(1);
        reference_uart.wait_it();
        reference_uart.read_if(1,ref_status);

		// Interruption en lecture, données transmises au checker
        if(ref_status[0] == 1) begin
		   uart_cover_group.do_cover(dut_status, ref_status);
           reference_uart.read_if(0,ref_read_dat);
           send_test.put(ref_read_dat);
           send_test.put(ref_status);
           end
		   
      sem_ref.put(1);
	  
      end //forever
   endtask : runReference
   
   task runDUT();
// Cette boucle traite en continu les interruptions du DUT (test de reception)
// la synchronisation se fait sur le matériel (signal inter)
     forever begin
        sem_dut.get(1);
        dut_uart.wait_it();
        dut_uart.read_if(1,dut_status);

		// Interruption en lecture, données transmises au checker
        if(dut_status[0] == 1) begin
		   uart_cover_group.do_cover(dut_status, ref_status);
           dut_uart.read_if(0,dut_read_dat);
           recept_test.put(dut_read_dat);
           recept_test.put(dut_status);
           end

        sem_dut.put(1);
		
      end //forever
   endtask : runDUT

endclass : Uart_receiver

        // Source des données
class Uart_write;
   mailbox envoi, reception;
   int nb_msg_send, nb_msg_receive;
   
   function new(mailbox envoi, int nb_msg_send, 
                mailbox reception, int nb_msg_receive);
      this.envoi = envoi;
      this.nb_msg_send = nb_msg_send;
      this.reception = reception;
      this.nb_msg_receive = nb_msg_receive;
   endfunction : new
   
   task run();
      logic [7:0] dat = $random();
      repeat(nb_msg_send) begin
         envoi.put(dat);
         $display("send gene : %d envoyée",dat);
         dat = $random();
         #($urandom_range(40e6)); 
        // retard aléatoire en picosecondes
      end //repeat
      
      //#200ms;
      
      repeat(nb_msg_receive) begin
         reception.put(dat);
         $display("reception gene : %d envoyée",dat);
         dat = $random();
         #($urandom_range(40e6)); 
        // retard aléatoire en picosecondes
      end //repeat
            
      #200ms; // Mise en someil du générateur
   endtask : run
endclass : Uart_write

        // Contrôle de la réception
class Uart_check;
// Les données sont reçues par deux voies : 
// directement du générateur dans la boite test
// à travers le périphérique dans la boite recu
   mailbox send_test_sent, send_test_received, recept_test_sent, recept_test_received, err_check;
   int nb_msg_send, nb_msg_receive;
   
   function new(mailbox driver_sent_test, int nb_msg_send, mailbox receiver_sent_test, 
                mailbox driver_recept_test, int nb_msg_receive, mailbox receiver_recept_test, err_check ); 
      this.send_test_sent = driver_sent_test;
      this.nb_msg_send = nb_msg_send;
      this.send_test_received = receiver_sent_test;
      this.recept_test_sent = driver_recept_test;
      this.nb_msg_receive = nb_msg_receive;
      this.recept_test_received = receiver_recept_test;
      this.err_check = err_check;
   endfunction : new
   
   task run();
      logic [7:0] rec_dat, test_dat, err_type, rec_status;
      
      repeat(nb_msg_send) begin
         send_test_received.get(rec_dat);
         send_test_received.get(rec_status);
         send_test_sent.get(test_dat);
         send_test_sent.get(err_type);
         case (err_type)
           1 : begin 
               $display("check send_test Injection d'erreur de parite notifiee");
               if (rec_status[2] == 1) 
                $display( "check send_test erreur de parite enregistree");
              else
                $display("check send_test erreur de parite non enregistree");
           end
           2 : begin
              $display("check send_test Injection d'erreur de trame notifiee");
              if ( rec_status[3] == 1) 
                $display( "check send_test erreur de trame enregistree");
              else
                $display("check send_test erreur de parite non enregistree");
           end
           3 : $display("check send_test Injection d'erreur de donnee notifiee");
         endcase
           
         if ( rec_dat == test_dat ) begin
           $display("check send_test: %d recu",rec_dat);
           if (err_type == 3) begin
             $display("check send_test l'injection d'erreur de donnee n'a pas fonctionne correctement");
             err_num +=1;
           end
         end
         else begin
           if (err_type == 3) begin
             $display("check send_test errone par injection d'erreur: %d recu",rec_dat);
             $display("check send_test la donnee original: %d transmis",test_dat);
           end
           else begin
             $display("check send_test Erreur de donnee : %d recu",rec_dat);
             $display("check send_test La donnee original: %d transmis",test_dat);
             err_num +=1;
           end
         end
         err_check.put(err_type);
             
      end //repeat
      
      repeat(nb_msg_receive) begin
        recept_test_received.get(rec_dat);
        recept_test_received.get(rec_status);
        recept_test_sent.get(test_dat);
        recept_test_sent.get(err_type);
        
        case (err_type)
           1 : begin
              $display("Check recpt_test Injection d'erreur de parite notifiee");
              if (rec_status[2] == 1) 
                $display("Check recpt_test Erreur de parite enregistree");
              else
                $display("Check recpt_test Erreur de parite non-enregistree");
           end
           2 : begin
              $display("Check recpt_test Injection d'erreur de trame notifiee");
              if (rec_status[3] == 1) 
                $display("Check recpt_test Erreur de trame enregistree");
              else
                $display("Check recpt_test Erreur de trame non-enregistree");
           end
           3 : $display("Check recpt_test Injection d'erreur de donnee notifiee");
         endcase
         if ( rec_dat == test_dat ) begin
           $display("check recpt_test: %d recu",rec_dat);
           if (err_type == 3) begin
             $display("Check recpt_test l'injection d'erreur de donnee n'a pas fonctionne correctement");
             err_num +=1;
           end
         end
         else begin
           if (err_type == 3) begin
             $display("check recpt_test errone par injection d'erreur: %d recu",rec_dat);
             $display("Check recpt_test La donnee original: %d transmis",test_dat);
           end
           else begin
             $display("Check recpt_test Erreur de donnee : %d recu",rec_dat);
             $display("Check recpt_test La donnee original: %d transmis",test_dat);
             err_num +=1;
           end
         end
         
         err_check.put(err_type);
                     
      end //repeat
   endtask : run
   
   function void bilan();
      $display("nombre d'erreurs : %d",err_num); 
   endfunction : bilan

endclass : Uart_check

endpackage : uart_test_classes
