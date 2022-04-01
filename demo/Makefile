# use /bin/bash to execute target bodies rather than /bin/sh
SHELL := /bin/bash

# assign default names of demo files and directories if not set
REPRO_DEMO_RUN_FILENAME ?= run.sh
REPRO_DEMO_OUT_FILENAME ?= run.txt

export REPRO_DEMO_OUT_DIRNAME ?= products

################################################################################
# targets for when there is NO demo run file in the working directory
################################################################################
ifeq ("$(wildcard ./$(REPRO_DEMO_RUN_FILENAME))","")

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

################################################################################
# alternative targets for when there IS a demo run file in the working directory
################################################################################
else

run: 
	bash $(REPRO_DEMO_RUN_FILENAME) > $(REPRO_DEMO_OUT_FILENAME)

clean:
	if [[ -f ./"$(REPRO_DEMO_OUT_FILENAME)" ]] ; then                       \
	    rm -v ./"$(REPRO_DEMO_OUT_FILENAME)" ;                              \
	fi

ifneq ($(origin REPRO_DEMO_TMP_DIRNAME),undefined) 
	if [[ -d ./"$(REPRO_DEMO_TMP_DIRNAME)" ]] ; then		                \
	    rm -vf ./"$(REPRO_DEMO_TMP_DIRNAME)"/* ;                            \
	    rmdir -v ./"$(REPRO_DEMO_TMP_DIRNAME)" ;                            \
	fi
endif

	if [[ -d ./"$(REPRO_DEMO_OUT_DIRNAME)" ]] ; then                       \
	    rm -vf ./"$(REPRO_DEMO_OUT_DIRNAME)"/* ;                           \
	    rmdir -v ./"$(REPRO_DEMO_OUT_DIRNAME)" ;                           \
	fi

endif
