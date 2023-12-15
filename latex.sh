#!/bin/bash

# use: ./latex -h

compiler='latexmk'

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'

show_help() {
    echo "Usage: ./$(basename "$0") [OPTIONS] <texfile.tex>"
    echo "Options:"
    echo "  -h: help"
    echo "  -c: compiler (options: latexmk, xelatex, default: $compiler)"
    echo "  -b: test option (for future)"
    exit 0
}
print_notice() {
    echo -e "${YELLOW}NOTICE: keep in mind that you need to specify graphicspath something like '{./src/}'${NC}"
}
clear_auxillary() {
    echo -e "${YELLOW}Clearing auxillary files...${NC}"
    rm -f *.aux *.fdb_latexmk *.fls *.log *.out *.synctex.gz *.toc *.bbl *.blg *.dvi
}

while getopts ":hc:b:" opt; do
  case $opt in
    h)
      show_help
      exit 0
      ;;
    c)
      compiler=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    :)
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

if [ -z "${!OPTIND}" ]; then
    echo "Error: <texfile.tex> is required."
    show_help
fi

texfile="${!OPTIND}"



if [ ! -f "$texfile" ]; then
    echo -e "${RED}Error: $texfile not found.${NC}"
    exit 1
fi

# compile
output_dir=$(dirname "$texfile")
basename=$(basename "$texfile")
name="${basename%.*}"
cd $output_dir
echo -e "${YELLOW}Compiling...${NC}"
if [ "$compiler" == "xelatex" ]; then
  xelatex "$basename"
elif [ "$compiler" == "latexmk" ]; then
  pdflatex "$basename"
  bibtex "$name".aux
  pdflatex "$basename"
  pdflatex "$basename"
else
  echo -e "${RED}Error: $compiler is not supported.${NC}"
  exit 1
fi


echo "+--------------------------------------+"
pwd
echo "+------------- diagnostics ------------+"
echo -e "compiler${LIGHT_BLUE} $compiler ${NC}"
echo -e "file${LIGHT_BLUE} $texfile ${NC}"
echo -e "basename${LIGHT_BLUE} $basename ${NC}"
echo -e "name${LIGHT_BLUE} $name ${NC}"

clear_auxillary
print_notice

exit