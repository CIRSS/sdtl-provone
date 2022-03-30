#!/usr/bin/env bash

# *****************************************************************************

run_cell C1 "Run the compute script" << END_CELL

python3 compute.py

END_CELL


# *****************************************************************************

run_cell C2 "Print csv file with final A, B, and C variables" << END_CELL

cat products/df_updated.csv

END_CELL


# *****************************************************************************

run_cell C3 "Print csv file with final Fahrenheit, Celsius, and Kelvin variables" << END_CELL

cat products/temps_updated.csv

END_CELL
