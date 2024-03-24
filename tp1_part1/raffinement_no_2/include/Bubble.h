///////////////////////////////////////////////////////////////////////////////
//
//	Bubble.h
//
///////////////////////////////////////////////////////////////////////////////
#ifndef _BUBBLE_H_
#define _BUBBLE_H_

#include <systemc.h>
#include <stdio.h>
#include "InterfaceRead.h"


///////////////////////////////////////////////////////////////////////////////
//
//	Class Bubble
//
///////////////////////////////////////////////////////////////////////////////
class Bubble : public sc_module
{
	public: 
		// Ports    
		/*
		
		À compléter
		
		*/
		sc_in_clk				clk;  
		
		sc_out<unsigned int>	address;
		sc_in<unsigned int> 	data;
		sc_out<bool>			request;
		sc_in<bool>				ack;
	
		// Constructor
		Bubble( sc_module_name zName );
		
		// Destructor
		~Bubble();
		
	private:
		// Process SystemC
		SC_HAS_PROCESS(Bubble);
		
		void bubble(void);
		void bubbleSort(unsigned int *ptr, int counter);
		enum readState {INIT, WAIT_NB_ELEM, READ_NB_ELEM, 
		WAIT_ELEM, READ_ELEM, POST_READ_ELEM, SORT_ELEMS};
		readState state = INIT;
		unsigned int* elems;
		unsigned int nbr_elem = 0;
		unsigned int addr = 0x00;
		unsigned int compteur = 0;

		// Attributs
		/*
		
		À compléter
		
		*/
};

#endif
