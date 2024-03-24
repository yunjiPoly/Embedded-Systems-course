///////////////////////////////////////////////////////////////////////////////
//
//	Bubble.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include "Bubble.h"


///////////////////////////////////////////////////////////////////////////////
//
//	Constructeur
//
///////////////////////////////////////////////////////////////////////////////
Bubble::Bubble( sc_module_name zName )
: sc_module(zName)
{
	SC_THREAD(interface);
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
//	Interface avec le module Reader
//
///////////////////////////////////////////////////////////////////////////////
void Bubble::interface(void)
{
	int nbr_elem = 0;
	unsigned int addr = 0x00;

	this->address->write(addr);
	this->request->write(true);

	do {
		wait(this->clk->posedge_event());
	} while (!this->ack.read());

	nbr_elem = this->data->read();
	this->request->write(false);

	unsigned int* elems;
	elems = new unsigned int[nbr_elem];

	for (int i = 0; i < nbr_elem; i++) {
		addr += 0x04;
		this->address->write(addr);
		this->request->write(true);

		do {
			wait(this->clk->posedge_event());
		} while (!this->ack.read());

		elems[i] = this->data->read();
		this->request->write(false);
	}

	bubbleSort(elems, nbr_elem);
	delete[] elems;


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

	for (int i = 0; i < counter; i++) {
		cout << ptr[i] << endl;
	}
	cout<<"]\n";

	// Tri
	cout << endl << "Bubble Begin " << sc_time_stamp() << endl ;

	for (int i = 0; i < counter - 1; i++) {
		bool echange = false;
		wait(this->clk->posedge_event());
		for (int j = 0; j < counter - i - 1; j++) {
			if (ptr[j] > ptr[j + 1]) {
				int temp = ptr[j];
				ptr[j] = ptr[j + 1];
				ptr[j + 1] = temp;

				echange = true;
			}
		}

		if (!echange) {
			break;
		}
	}
	cout << "Bubble end " << sc_time_stamp() << endl ;
	
	cout<<"apres tri: [" << endl;
	
	// Affichage après tri
	for (int i = 0; i < counter; i++) {
		cout << ptr[i] << endl;
	}
	cout<<"]\n";
}
