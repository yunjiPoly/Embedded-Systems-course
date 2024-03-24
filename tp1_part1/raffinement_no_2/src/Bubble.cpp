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
	/*
	
	À compléter
	
	*/

	SC_METHOD(bubble);
	sensitive<<clk.pos();
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
//	Bubble: communication + traitement dans une machine à états
//
///////////////////////////////////////////////////////////////////////////////
void Bubble::bubble(void)
{
	switch(state) {
		case INIT:
			this->address->write(addr);
			this->request->write(true);
			state = WAIT_NB_ELEM;
			break;
		case WAIT_NB_ELEM :
			if (this->ack.read()){
				state = READ_NB_ELEM;
				break;
			} else break;

		case READ_NB_ELEM:
			nbr_elem = this->data->read();
			this->request->write(false);

			elems = new unsigned int[nbr_elem];
			cout << endl << "Bubble Begin " << sc_time_stamp() << endl ;

			state = POST_READ_ELEM;
			break;
		case POST_READ_ELEM:

			// Debut dans loop for
			if (compteur != nbr_elem) {
				addr += 0x04;
				this->address->write(addr);
				this->request->write(true);
				// le wait
				state = WAIT_ELEM;
				break;
			}
			// quand loop fini
			else {
				// Affichage avant tri
				std::cout<<"Affichage avant tri: [" << endl;

				for (unsigned int i = 0; i < nbr_elem; i++) {
				cout << elems[i] << endl;
				}
				cout<<"]\n";
				state = SORT_ELEMS;
				break;
			}

		// wait dans boucle for
		case WAIT_ELEM:
			if(this->ack.read()){
				state = READ_ELEM;
				break;
			}
			else break;
		// a la fin dans boucle for
		// fait le read et aller a la prochain iteration
		case READ_ELEM:
				elems[compteur] = this->data->read();
				this->request->write(false);
				compteur++;
				state = POST_READ_ELEM;
				break;
		case SORT_ELEMS:
				bubbleSort(elems, nbr_elem);
				delete[] elems;
				// Arrêt de la simulation
				sc_stop();
				break;
	}
	/*
	
	À compléter
		

	
	*/
}

///////////////////////////////////////////////////////////////////////////////
//
//	bubbleSort
//
///////////////////////////////////////////////////////////////////////////////
void Bubble::bubbleSort(unsigned int *ptr, int counter)
{
	// Tri
	for (int i = 0; i < counter - 1; i++) {
		bool echange = false;
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
