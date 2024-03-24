///////////////////////////////////////////////////////////////////////////////
//
//	wrapper_console_TLM.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include "wrapper_console_TLM.h"


///////////////////////////////////////////////////////////////////////////////
//
//	Constructeur
//
///////////////////////////////////////////////////////////////////////////////
wrapper_console_TLM::wrapper_console_TLM(sc_module_name zName, unsigned long ulStartAdress, unsigned long ulEndAdress)
: sc_module(zName)
{
	//Assigne les variables
	m_ulStartAdress = ulStartAdress;
	m_ulEndAdress = ulEndAdress;
	socket.register_b_transport(this, &wrapper_console_TLM::b_transport);
}

///////////////////////////////////////////////////////////////////////////////
//
//	Destructeur
//
///////////////////////////////////////////////////////////////////////////////
wrapper_console_TLM::~wrapper_console_TLM()
{
}

///////////////////////////////////////////////////////////////////////////////
//
//	b_transport : répond aux requêtes envoyées par le initiator
//
///////////////////////////////////////////////////////////////////////////////
void wrapper_console_TLM::b_transport( transaction_type& trans, sc_time& delay )
{
	command_type	 cmd = trans.get_command();
	sc_dt::uint64    add = trans.get_address();
	unsigned char*   ptr = trans.get_data_ptr();
	unsigned int     len = trans.get_data_length();
	unsigned char*   byt = trans.get_byte_enable_ptr();
	unsigned int     wid = trans.get_streaming_width();
	sc_time dly = sc_time(25, SC_NS);
	
	//Vérification 
	if (byt != 0 || wid < len)
	  SC_REPORT_ERROR("TLM-2", "Target does not support given generic payload transaction");
	
	// On vérifie si la requête est de lecture ou écriture
	if ( cmd == tlm::TLM_READ_COMMAND ){
		busLT_slave_read(add, ptr, len);
	}
	else if ( cmd == tlm::TLM_WRITE_COMMAND ){
		busLT_slave_write(add, ptr, len);
	}
	
	//Temps d'attente
	delay += dly;
	
	// Aquittement
	trans.set_response_status( tlm::TLM_OK_RESPONSE );
}

///////////////////////////////////////////////////////////////////////////////
//
//	busLT_slave_read
//
///////////////////////////////////////////////////////////////////////////////
void wrapper_console_TLM::busLT_slave_read(sc_dt::uint64 add, unsigned char* ptrData, unsigned int len)
{
	cout << "Il est impossible de lire a partir de la Console" << endl;
}


///////////////////////////////////////////////////////////////////////////////
//
//	busLT_slave_write
//
///////////////////////////////////////////////////////////////////////////////
void wrapper_console_TLM::busLT_slave_write(sc_dt::uint64 add, unsigned char* ptrData, unsigned int len)
{
	unsigned int data;

	memcpy(&data, ptrData, len);
	
	// On récupère la donnée
	Wrapper_Data_OutPort.write( data );
	
	// On indique que la donnée est prête
	Wrapper_Enable_OutPort.write( true );
	
	// Attendre 	
	wait(Wrapper_Ready_InPort.default_event());

	// On indique que la donnée est prête
	Wrapper_Enable_OutPort.write( false );
}
