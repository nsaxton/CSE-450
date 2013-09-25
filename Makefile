CXX	= g++

.cc.o:
	$(CXX) -c $< -o $*.o

default: all

all: tube-parse

proj2.tab.cc: proj2.y
	bison -oproj2.tab.cc -b proj2 -d proj2.y

proj2.yy.cc: proj2.lex
	flex -oproj2.yy.cc proj2.lex

tube-parse: proj2.tab.o proj2.yy.o
	$(CXX) -o tube-parse proj2.tab.o proj2.yy.o -ll -ly

clean:
	rm -f proj2.tab.cc proj2.tab.hh proj2.yy.cc proj2.tab.o proj2.yy.o proj2

