///////////////////////////////////////////////////////////////////////////////
//
//	RAM.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include "RAM.h"


///////////////////////////////////////////////////////////////////////////////
//
//	Constructeur
//
///////////////////////////////////////////////////////////////////////////////
RAM::RAM( sc_module_name zName, const char *zFileName, unsigned long ulRAMSize, bool bVerbose )
: sc_module(zName), m_ulRAMSize(ulRAMSize), m_bVerbose(bVerbose)
{
	// Variable
	FILE * pFile;
	size_t result;

	// Initialisation
	m_ptrRAM = NULL;
	
	// Allocation de la mémoire
	m_ptrRAM = malloc( m_ulRAMSize );
	
	// On valide si la mémoire est allouée
	if ( m_ptrRAM == NULL )
	{
		cout << "Erreur lors de l'allocation de " << m_ulRAMSize << " octets" << endl;
		
		// Fin de la simulation
		m_bError = true;
	}

	// On initialise la mémoire
	memset(m_ptrRAM, 0, m_ulRAMSize);
	
	// Ouverture du fichier
	pFile = fopen( zFileName, "rb" );
	
	// Validation
	if (pFile == 0)
	{
		cout << "Erreur lors de l'ouverture du fichier d'entree" << endl;
		
		// Fin de la simulation
		m_bError = true;
	}
	else
	{
		// On va chercher la taille du fichier
		fseek( pFile , 0 , SEEK_END );
		m_ulSize = ftell(pFile);
		rewind(pFile);
				
		// On s'assure que le fichier n'est pas trop volumineux
		if ( m_ulSize > m_ulRAMSize )
		{
			cout << "Fichier d'entree trop volumineux pour la RAM" << endl;
			
			// Fin de la simulation
			m_bError = true;
		}
		else
		{
			// On remplie le contenu de la mémoire avec le fichier d'entrée
			result = fread( m_ptrRAM, 1, m_ulSize, pFile );
			
			// On valide que tout s'est bien déroulé
			if (result != m_ulSize)
			{
				cout << "Erreur lors de l'ecriture du fichier d'entree en memoire" << endl;
				
				// Fin de la simulation
				m_bError = true;
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
//
//	Destructeur
//
///////////////////////////////////////////////////////////////////////////////
RAM::~RAM()
{
	// On vide la mémoire
	if ( m_ptrRAM != NULL )
		free( m_ptrRAM );
}


///////////////////////////////////////////////////////////////////////////////
//
//	Read
//
///////////////////////////////////////////////////////////////////////////////
unsigned int RAM::Read(unsigned int uiAddr)
{
	// Variable
	unsigned int uiData = 0;
	
	if ( uiAddr >= m_ulRAMSize )
	{
		cout << "Lecture hors de la plage de la RAM" << endl;
		
		// Fin de la simulation
		sc_stop();
	}
	else
	{
		// On avertie l'usager
		if ( ( uiAddr >= m_ulSize ) && m_bVerbose )
			cout << "Lecture de la memoire hors de la plage du fichier d'entree" << endl;
			
		// On copie le contenu de la mémoire
		memcpy( &uiData, (void*)((long)(m_ptrRAM) + uiAddr), 4);
	}
	
	// Retourne le contenu de la mémoire
	return uiData;
}
