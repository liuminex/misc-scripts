#!/bin/bash

fix_pdf () {
  fix_crop "$1" "tmp_cropped.pdf"
  #mutool poster -x 1 -y 2 "$1" "tmp_split_to_single.pdf"
  #fix_whitespace tmp_split_to_single.pdf tmp_no_whitespace.pdf
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH -sOutputFile=tmp_compressed.pdf tmp_cropped.pdf
  #rm "$1" "tempsplit.pdf" "fixed.pdf"
  mv "tmp_compressed.pdf" "${1%.*}_c.pdf"
  rm tmp_*
}

fix_crop () {
  input_pdf=$1
  output_pdf=$2

  pdftk "$input_pdf" burst output tmp_page_%04d.pdf
  for temp_page in tmp_page_*.pdf; do

    # Define the centered rectangle coordinates (left, top, right, bottom)
    left=55 #apo aristera sta deksia
    right=538 #apo deksia sta aristera

    x=424
    bottom=$((36 + x)) #apo katw pros panw
    top=$((310 + x)) #apo katw pros panw!
    pdfcrop --bbox "$left $bottom $right $top" "$temp_page" "cropped_${temp_page}_1"

    x=69
    bottom=$((36 + x)) #apo katw pros panw
    top=$((310 + x)) #apo katw pros panw!
    pdfcrop --bbox "$left $bottom $right $top" "$temp_page" "cropped_${temp_page}_2"

  done
  rm tmp_page*.pdf
  pdftk cropped_tmp_page_*.pdf_* cat output "$output_pdf"
  rm cropped_tmp_page_* doc_data.txt
}

rm tmp_*.pdf cropped_*.pdf cropped_tmp_page_* doc_data.txt
for f in *.pdf; do
  fix_pdf "$f"
done
exit
