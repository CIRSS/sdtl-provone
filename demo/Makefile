# use /bin/bash to execute target bodies rather than /bin/sh
SHELL := /bin/bash

# assign default names of demo files and directories if not set
REPRO_DEMO_RUN_FILE     ?= run.sh
REPRO_DEMO_OUT_FILE     ?= run.txt
REPRO_DEMO_SCRATCH_DIR  ?= .scratch
REPRO_DEMO_PRODUCTS_DIR ?= products

######################################################################################
# define targets for when there is no REPRO_DEMO_RUN_FILE in the working directory
######################################################################################

ifeq ("$(wildcard ./$(REPRO_DEMO_RUN_FILE))","")

# Example directory names start with a digit
EXAMPLE_DIRS = $(wildcard [0-9]*/)

run:
	for dir in $(EXAMPLE_DIRS); do                                          \
		echo;                                                               \
		echo "---------- Running example $$dir -------------" ;	            \
		$(MAKE) -C $$dir run;                                               \
	done

clean:
	for dir in $(EXAMPLE_DIRS); do                                          \
		echo;                                                               \
		echo "------- Cleaning example $$dir ----------------" ;            \
		$(MAKE) -C $$dir clean;                                             \
	done

######################################################################################
# alternative targets for when there is a REPRO_DEMO_RUN_FILE in the working directory
######################################################################################

else

run: 
	bash $(REPRO_DEMO_RUN_FILE) > $(REPRO_DEMO_OUT_FILE)


clean:
	if [[ -f ./"$(REPRO_DEMO_OUT_FILE)" ]] ; then                           \
	    rm -v ./"$(REPRO_DEMO_OUT_FILE)" ;                                  \
	fi

	if [[ -d ./"$(REPRO_DEMO_SCRATCH_DIR)" ]] ; then		                \
	    rm -vf ./"$(REPRO_DEMO_SCRATCH_DIR)"/* ;                            \
	    rmdir -v ./"$(REPRO_DEMO_SCRATCH_DIR)" ;                            \
	fi

	if [[ -d ./"$(REPRO_DEMO_PRODUCTS_DIR)" ]] ; then                       \
	    rm -vf ./"$(REPRO_DEMO_PRODUCTS_DIR)"/* ;                           \
	    rmdir -v ./"$(REPRO_DEMO_PRODUCTS_DIR)" ;                           \
	fi

endif
