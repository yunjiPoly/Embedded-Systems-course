///////////////////////////////////////////////////////////////////////////////
//
//	main.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include <systemc.h>
#include "Bubble.h"
#include "Wrapper.h"
#include "DataRAM.h"

#define RAMSIZE 0x400

// Global variables
bool m_bError = false;

///////////////////////////////////////////////////////////////////////////////
//
//	Main
//
///////////////////////////////////////////////////////////////////////////////
int sc_main(int arg_count, char **arg_value)
{
	// Variables
	int sim_units = 2; //SC_NS 

	// Clock
	/*
	
	À compléter
	
	*/
	sc_clock sClk( "SysClock", 4000, SC_NS, 0.5 );

	// Instanciation des composants
	/*
	
	À compléter
	
	*/
	Bubble iBubble("Bubble");
	Wrapper iWrapper("Wrapper");
	DataRAM iDataRAM("DataRAM", "memory/mem.hex", RAMSIZE, false);
	
	// Déclaration des signaux
	/*
	
	À compléter
	
	*/
	sc_buffer<unsigned int> sData;
	sc_buffer<unsigned int> sAddress;
	sc_buffer<bool> sAck;
	sc_buffer<bool> sRequest;
	// Connexion des ports
	/*
	
	À compléter
	
	*/
	iBubble.clk(sClk);

	iBubble.address(sAddress);
	iBubble.data(sData);
	iBubble.request(sRequest);
	iBubble.ack(sAck);

	iWrapper.clk(sClk);

	iWrapper.dataPortRAM(iDataRAM);
	iWrapper.data(sData);
	iWrapper.address(sAddress);
	iWrapper.ack(sAck);
	iWrapper.request(sRequest);
	// Démarrage de l'application
	if (!m_bError)
	{
		cout << "Demarrage de la simulation." << endl;
		sc_start(-1, sc_core::sc_time_unit(sim_units));
		cout << endl << "Simulation s'est terminee a " << sc_time_stamp() << endl;
	}
	// Fin du programme
	return 0;
}
