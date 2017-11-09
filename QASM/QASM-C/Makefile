
CSRCS= 			src/misc.cpp \
				src/qcomputer.cpp \
				src/qgate.cpp \
				src/qubit_vector.cpp \
				
MAIN=			src/main.cpp 
				
OBJS=			$(CSRCS:src/%.cpp=obj/%$(DEBUG_EXT).o) 

DEPS=			$(CSRCS:src/%.cpp=dep/%$(DEBUG_EXT).d)
		
INCL=			-Iinc

TARGET_LIB=		lib/libqasm$(DEBUG_EXT).so

EXE=			exe/qcomp

CXX=			g++

CC=				gcc

DIRS=			dep	\
				obj \
				lib \
				exe

ifeq ($(MODE),debug)
CXXFLAGS+=		-g
DEBUG_EXT=		_g
endif

-include $(DEPS)

all: 	$(TARGET_LIB)

debug:
	make exe "MODE=debug"
	
exe:	$(EXE)
	
$(EXE):	all $(MAIN)
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCL) $(MAIN) -Llib -lqasm -o $@
			
$(TARGET_LIB): 	$(OBJS)
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCL) -shared -o $@ $(OBJS)
	
obj/%$(DEBUG_EXT).o:	src/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCL) -c -o $@ $<
	
obj/%$(DEBUG_EXT).o:	src/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CXXFLAGS) $(INCL) -c -o $@ $<
	
dep/%$(DEBUG_EXT).d:	src/%.cpp	src/%.c
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCL) -MM -MT $(@:dep/%.d=obj/%.o) $< \
		| sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' > $@
	
clean:
	rm -f $(TARGET_LIB) $(OBJS) $(DEPS) $(EXE)
	for d in dep lib obj;	\
	do						\
		if [ -d $$d ] ;		\
		then				\
			rmdir $$d ;		\
		fi ;				\
	done

clean_g:
	make clean "MODE=debug"
