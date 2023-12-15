#execute: place this script in the desired folder and execute with ./pdfmetaorder.sh
#renames all pdfs in the same folder where this script is
#new names are: yyyymmdd_author_[prev file name].pdf, where gd and author are from pdfinfo
#IT RENAMES THEM - DOES NOT CRERATE COPIES, SO CP THEM BEFORE YOU RUN THIS SCRIPT
 
for f in *.pdf; do
  ns=$(echo "$f" | tr " " _)
  fn="${f}"

  str=$( pdfinfo "$fn" )

  #echo "-----------result: " $str "---------"
  ar=($str)

  auth="unknown"
  gd="unknown"
  for ((i=0;i<${#ar[@]};i++));
  do
    w="${ar[$i]}"
    #echo $w
    if [ "$w" == "Author:" ]; then
      auth="${ar[i+1]}_${ar[i+2]}"
    fi
  done
  for ((i=0;i<${#ar[@]};i++));
  do
    w="${ar[$i]}"
    #echo $w
    if [ "$w" == "CreationDate:" ]; then
      gd="${ar[i+5]}_${ar[i+2]}_${ar[i+3]}"
    fi
  done

  nfn="${gd}_${auth}_${ns}"
  #echo $nfn
  #echo cp $fn $nfn
  mv "$fn" $nfn
done;
exit;
