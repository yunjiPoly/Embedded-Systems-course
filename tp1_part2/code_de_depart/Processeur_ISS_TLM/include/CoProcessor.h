///////////////////////////////////////////////////////////////////////////////
//
//	CoProcessor.h
//
///////////////////////////////////////////////////////////////////////////////
#ifndef COPROCESSOR_H_
#define COPROCESSOR_H_

#include <systemc.h>
#include <stdio.h>
#include <iostream>
#include <vector>
using namespace std;


///////////////////////////////////////////////////////////////////////////////
//
//	Classe CoProcessor
//
///////////////////////////////////////////////////////////////////////////////
class CoProcessor : public sc_module
{
	public: 
		// Variable
		sc_in_clk				ClockPort;
		sc_in<unsigned int>  	CoProcessor_Data_InPort;
		sc_out<unsigned int>  	CoProcessor_Data_OutPort;
		sc_in<bool>				CoProcessor_Enable_InPort;
		sc_out<bool>			CoProcessor_Ready_OutPort;		
		sc_in<bool>				CoProcessor_RW_InPort;
	
		// Constructeur
		CoProcessor( sc_module_name zName );
		
		// Destructeur
		~CoProcessor();
		
	private:
		// Processus SystemC
		SC_HAS_PROCESS(CoProcessor);
		
		// Méthode
		void thread(void);
		void bubbleSort(unsigned int *ptr, int counter);
		
		// Registres
		// Use integer array instead of sc_signal (which is useless)
		//sc_signal<int> reg[4];
		int reg[4];
};

#endif
