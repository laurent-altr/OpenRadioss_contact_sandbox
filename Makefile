# Set default compiler
COMP ?= gnu

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ifeq ($(COMP),gnu)
CXX=g++
FC=gfortran
INCDIR=./include
CXXFLAGS=-fopenmp -O2 -std=c++11
FCINC=-I$(ROOT_DIR)/${INCDIR} -J ./
FCFLAGS=-O2 -g -fbacktrace -march=native -fopenmp -DMYREAL8 -ffast-math -finit-real=nan -falign-commons -ffixed-line-length-132
LDFLAGS=
LIBS=-lstdc++
endif

ifeq ($(COMP),intel)
CXX=icpx
FC=ifx
INCDIR=./include
CXXFLAGS=-fiopenmp -O2 -std=c++11 -fopenmp-version=52
FCINC=-I$(ROOT_DIR)/${INCDIR} -module ./
FCFLAGS=-O2 -g -traceback -axSSE3,COMMON-AVX512 -no-fma -fp-model precise -fimf-use-svml=true -qopenmp -DMYREAL8 -ftz -extend-source -assume buffered_io -align array64byte
LDFLAGS=
LIBS=-lstdc++
endif


ifeq ($(COMP),nvfortran)
CXX=pgc++
FC=nvfortran
INCDIR=./include
CXXFLAGS=-mp -O2 -std=c++11
FCINC=-I$(ROOT_DIR)/${INCDIR} -module ./
FCFLAGS=-O2 -g -traceback -Minfo=all -mp -Mextend -DMYREAL8 -fast -Mfixed -Mallocatable=03
LDFLAGS=
LIBS=-lstdc++
endif


# Executables
EXE1=poc_openmp_$(COMP)

EXES=$(EXE1)

all: clean $(EXES)

OBJS1=compare_cand.o \
        unlimit_stack.o \
        constant_mod.o \
        inter7_filter_cand.o \
        inter7_penetration.o \
        inter7_candidate_pairs.o \
        inter7_gather_cand.o \
        collision_mod.o \
        unit_test1.o

compare_cand.o: compare_cand.cpp

unlimit_stack.o: compare_cand.cpp

constant_mod.o: constant_mod.F \
        $(INCDIR)/my_real.inc

inter7_filter_cand.o: inter7_filter_cand.F \
        constant_mod.o \
        collision_mod.o \
        inter7_gather_cand.o \
        inter7_penetration.o \
        $(INCDIR)/my_real.inc

inter7_penetration.o: inter7_penetration.F \
        constant_mod.o \
        collision_mod.o \
        $(INCDIR)/my_real.inc

inter7_candidate_pairs.o: inter7_candidate_pairs.F \
        constant_mod.o \
        collision_mod.o \
        inter7_filter_cand.o \
        $(INCDIR)/my_real.inc

inter7_gather_cand.o: inter7_gather_cand.F \
        collision_mod.o \
        $(INCDIR)/my_real.inc

collision_mod.o: collision_mod.F

unit_test1.o: unit_test1.F \
        inter7_candidate_pairs.o

# Rules for building executables
$(EXE1): $(OBJS1)
	$(FC) $(FCFLAGS) $^ -o $@ $(LDFLAGS) $(LIBS)

%.o: %.F
	$(FC) $(FCINC) $(FCFLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: clean all $(EXE1)
	-./$(EXE1) t10m.dat

.PHONY: clean
clean:
	-/bin/rm -f $(EXES) *.o *.optrpt *~ *.mod *.modmic *.d

