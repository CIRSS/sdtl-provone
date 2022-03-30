RUN_SCRIPT_FILE=./run.sh
RUN_OUTPUT_FILE=./run.txt
RUN_PRODUCTS_DIR=./products
RUN_SCRATCH_DIR=./.scratch
DIRS=${RUN_PRODUCTS_DIR}

all: run

clean:
	rm -fv ${RUN_OUTPUT_FILE}
	rm -rfv ${RUN_PRODUCTS_DIR}
	rm -rfv ${RUN_SCRATCH_DIR}

run: 
	bash ${RUN_SCRIPT_FILE} > ${RUN_OUTPUT_FILE}
