# PrimerDesign
PrimerDesign is a small tool in order to avoid repeated operations which is frustating and time-consuming.
## primer.R
This is an R script to concatenate two sequences: one is a 25bp overlap sequence for Gibson assembly, and the other is a sequence about 20bp whose length is adjusted based on Tm (melting temperature). 

This program can be used as a command line tool in a UNIX system, providing the necessary parameters. The input file is a `.csv` file, in which each row contains overlap sequences and reference  sequence (contain different insertion sites) to generate a series of primers with the same 25bp overlap sequence, and And the output file is also  `.csv` files containing primer sequence generated, the number of which equals to row number of input file.

```shell
Usage: primer.R [options]

Options:
	-o CHARACTER, --output=CHARACTER
		Set the prefix of output file name

	-n INTEGER, --number=INTEGER
		Number of primers to design

	-i CHARACTER, --input=CHARACTER
		Input file consist of overlap sequence for Gibson assembly and reference sequence

	-g NUMERIC, --gap=NUMERIC
		Selection gap for insertion sites [default= 1]

	-h, --help
		Show this help message and exit
```

### Usage example

`input.csv` is provided too, and you can run the following command in a UNIX system to get familiar with it. Remember to put `primer.R` and `input.csv` under the same file directory unless using an absolute path.

```shell
Rscript primer.R -o EP3_ICL3 -g 1 -n 10 -i input.csv
```

