///////////////////////////////////////////////////////////////////////////////
//
//	Bubble.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include "Bubble.h"
#include <iostream>

using namespace std;

///////////////////////////////////////////////////////////////////////////////
//
//	Constructeur
//
///////////////////////////////////////////////////////////////////////////////
Bubble::Bubble( sc_module_name zName )
: sc_module(zName)
{
	SC_THREAD(interface);
	/*
	
	À compléter
	
	*/
}


///////////////////////////////////////////////////////////////////////////////
//
//	Destructeur
//
///////////////////////////////////////////////////////////////////////////////
Bubble::~Bubble()
{

}


///////////////////////////////////////////////////////////////////////////////
//
//	Interface avec le module Reader: sc_thread ou sc_method
//
///////////////////////////////////////////////////////////////////////////////
void Bubble::interface(void)
{	
	int counter = 0;
	unsigned int addr = 0x00;
	unsigned int* dataPointer;

	// 1ere lecture: nombre d'éléments à trier
	counter = readPort->Read(addr);
	dataPointer = new unsigned int[counter]();
	// Lecture des éléments à trier
	for ( int i = 0 ; i < counter; i++){
		addr += 0x04;
		dataPointer[i] = readPort->Read(addr);
	}

	//Appel à bubble sort
	bubbleSort(dataPointer, counter);
	// delete[] dataPointer;

	// Arrêt de la simulation
	sc_stop();

}


///////////////////////////////////////////////////////////////////////////////
//
//	bubbleSort
//
///////////////////////////////////////////////////////////////////////////////
void Bubble::bubbleSort(unsigned int *ptr, int counter)
{
	// Affichage avant tri
	std::cout<<"Affichage avant tri: [" << endl;
	for ( int i = 0; i < counter; i++) {
		std::cout<< ptr[i] << endl;
	}
	cout<<"]\n";

	// Tri
    for (int i = 0; i < counter - 1; i++) {
        for (int j = 0; j < counter - i - 1; j++) {
            if (ptr[j] > ptr[j + 1]) {
                int temp = ptr[j];
                ptr[j] = ptr[j + 1];
                ptr[j + 1] = temp;
            }
        }
    }
	// Affichage après tri
	cout<<"apres tri: [" << endl;
	for ( int i = 0; i < counter; i++) {
		std::cout<< ptr[i] << endl;

	}
	cout<<"]\n";

}
