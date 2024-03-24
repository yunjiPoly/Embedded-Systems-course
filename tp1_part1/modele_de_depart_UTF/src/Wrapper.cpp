///////////////////////////////////////////////////////////////////////////////
//
//	Wrapper.cpp
//
///////////////////////////////////////////////////////////////////////////////
#include "Wrapper.h"

///////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
///////////////////////////////////////////////////////////////////////////////
Wrapper::Wrapper(sc_module_name zName)
: sc_module(zName)
{
}

///////////////////////////////////////////////////////////////////////////////
//
//	Destructor
//
///////////////////////////////////////////////////////////////////////////////
Wrapper::~Wrapper()
{
}

///////////////////////////////////////////////////////////////////////////////
//
//	read
//
///////////////////////////////////////////////////////////////////////////////
unsigned int Wrapper::Read(unsigned int uiAddr)
{
	// Calling DataRAM using LMBIF interface (read)
	return dataPortRAM->Read(uiAddr);
}