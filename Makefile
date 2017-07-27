
# Generate SASS for the first version of each major architecture.
#   This will cover that entire major architecture.
# Generate SASS for important minor versions.
# Generate PTX for the last named architecture for future support.
ARCH=\
  -gencode arch=compute_20,code=compute_20 \
  -gencode arch=compute_20,code=sm_20 \
  -gencode arch=compute_35,code=compute_35 \
  -gencode arch=compute_35,code=sm_35 \
  -gencode arch=compute_52,code=compute_52 \
  -gencode arch=compute_52,code=sm_52 \
  -gencode arch=compute_61,code=compute_61 \
  -gencode arch=compute_61,code=sm_61

OPTIONS=-std=c++11 -Xcompiler="-Wundef" -O2 -g -Xcompiler="-Werror" -lineinfo  --expt-extended-lambda -use_fast_math -Xptxas="-v" -I src

all: \
	prereq \
	tests \
	tutorials \
	demos

prereq:
	mkdir -p bin
	cp demo/statecity.csv bin
    
# kernel tests
tests: \
	test_reduce \
	test_scan \
	test_bulkremove \
	test_merge \
	test_bulkinsert \
	test_mergesort \
	test_segsort \
	test_load_balance \
	test_intervalexpand \
	test_intervalmove \
	test_sortedsearch \
	test_join \
	test_segreduce \
	test_compact

test_reduce: tests/test_reduce.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_scan: tests/test_scan.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_bulkremove: tests/test_bulkremove.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_merge: tests/test_merge.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_bulkinsert: tests/test_bulkinsert.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_mergesort: tests/test_mergesort.cu	src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_segsort: tests/test_segsort.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_load_balance: tests/test_load_balance.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_intervalexpand: tests/test_intervalexpand.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_intervalmove: tests/test_intervalmove.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_sortedsearch: tests/test_sortedsearch.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_join: tests/test_join.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_segreduce: tests/test_segreduce.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

test_compact: tests/test_compact.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

# simple tutorials

tutorials: \
	tut_01_transform \
	tut_02_cta_launch \
	tut_03_launch_box \
	tut_04_launch_custom \
	tut_05_iterators \

tut_01_transform: tutorial/tut_01_transform.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

tut_02_cta_launch: tutorial/tut_02_cta_launch.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

tut_03_launch_box: tutorial/tut_03_launch_box.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

tut_04_launch_custom: tutorial/tut_04_launch_custom.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

tut_05_iterators: tutorial/tut_05_iterators.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

demos: \
	cities \
	bfs \
	bfs2 \
	bfs3

cities: demo/cities.cu src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $<

bfs: demo/bfs.cu demo/graph.cxx src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $< demo/graph.cxx

bfs2: demo/bfs2.cu demo/graph.cxx src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $< demo/graph.cxx

bfs3: demo/bfs3.cu demo/graph.cxx src/moderngpu/*.hxx
	nvcc $(ARCH) $(OPTIONS) -o bin/$@ $< demo/graph.cxx

clean:
	rm -rf bin