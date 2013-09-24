#include <string>
#include <map>
#include "symbol_table.h"

using namespace std;

symbol_table::symbol_table() 
{

}

void symbol_table::insert(string id, int linenumber) 
{
	symbol* newSymbol;
	newSymbol->linenumber = linenumber;
	newSymbol->id = id;
	newSymbol->init = false;
	symbol_map.insert(std::pair<string, symbol>(id, newSymbol));
}

void symbol_table::insert(string id, int value, int linenumber) 
{
	symbol* newSymbol;
	newSymbol->linenumber = linenumber;
	newSymbol->id = id;
	newSymbol->value = value;
	newSymbol->init = true;
	symbol_map.insert(std::pair<string, symbol>(id, newSymbol));
}

void symbol_table::assign(string id, int value) 
{
	symbol symb = getSymbol(id);
	symb.value = value;
	symb.init = true;
}

symbol symbol_table::getSymbol(string id) 
{
	return symbol_map.find(id)->second;
}