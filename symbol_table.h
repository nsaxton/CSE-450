#include <map>

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

using namespace std;

	struct symbol {
		char * id;
		int linenumber;
		int value;
		bool init;
	};

class symbol_table
{		

	public:
		symbol_table();

		void insert(char * id, int linenumber);
		void insert(char * id, int value, int linenumber);
		void assign(char * id, int value);
		symbol getSymbol(char * id);
	private:
		map<char*, symbol> symbol_map;
}

#endif SYMBOL_TABLE_H

symbol_table::symbol_table() 
{

}

void symbol_table::insert(char * id, int linenumber) 
{
	symbol* newSymbol;
	newSymbol->linenumber = linenumber;
	newSymbol->id = id;
	newSymbol->init = false;
	symbol_map.insert(std::pair<char*, symbol>(id, newSymbol));
}

void symbol_table::insert(char * id, int value, int linenumber) 
{
	symbol* newSymbol;
	newSymbol->linenumber = linenumber;
	newSymbol->id = id;
	newSymbol->value = value;
	newSymbol->init = true;
	symbol_map.insert(std::pair<char * , symbol>(id, newSymbol));
}

void symbol_table::assign(char * id, int value) 
{
	symbol symb = getSymbol(id);
	symb.value = value;
	symb.init = true;
}

symbol symbol_table::getSymbol(char * id) 
{
	return symbol_map[id];
}
