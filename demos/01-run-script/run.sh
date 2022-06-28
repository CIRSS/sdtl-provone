#!/usr/bin/env bash

# *****************************************************************************

bash_cell C1 << END_CELL

# Run the compute script

python3 compute.py

END_CELL


# *****************************************************************************

bash_cell C2 << END_CELL

# Print csv file with final A, B, and C variables

cat products/df_updated.csv

END_CELL


# *****************************************************************************

bash_cell C3 << END_CELL

# Print csv file with final Fahrenheit, Celsius, and Kelvin variables

cat products/temps_updated.csv

END_CELL
