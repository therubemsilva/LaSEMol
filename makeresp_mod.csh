#!/bin/bash
# a script to generate resp input file from gamess dat file

########################
#Modified by liuyujie  #
#Date 2019.01.09       #
########################

if [ $# -lt 1 ];then
  echo "Usage:$0 gamess.dat"
  exit 1
fi

if [ ! -e $1 ];then
  echo "Input file $1 not exist!"
  exit 2
fi

# judge whether dat file from gamess is right for fitting resp charges 
opt='$ELPOT  IEPOT=1 WHERE=PDC OUTPUT=PUNCH $END'

# judge whether dat file includes esp data 
if [[ `grep "POTENTIAL COMPUTED FOR" $1`a == a ]];then
  echo "Your $1 does not appear to have ESP data"
  # judge file suffix
  file=$1
  if [[ "${file##*.}" == "dat" || "${file##*.}" == "DAT" ]];then
    echo "Add the line below to ${file%.*}.inp and rerun"
    echo "$opt"
  else
    echo "Perhaps, you are specifying a GAMESS output (not punch) file?"
  fi
  exit 3
fi

# define output file
file=$1
resp=${file%.*}.in
esp=${file%.*}.esp

# create .in file for resp
cat > $resp << EOF
TITLE
 &cntrl nmol=1, ihfree=1
 &end
1.0
EOF

# find molecule name from dat file
n=`grep -n "DATA" $1 |head -1 |cut -d: -f1`
let n++
sed -n -e "${n}p" $1 >> $resp

# find molecule net charge and the number of atom
na=`grep "POTENTIAL COMPUTED FOR" $1 | tail -1`
ch=$(echo $na |cut -d' ' -f9)
na=$(echo $na |cut -d' ' -f5)
echo "$ch $na" |awk '{printf "%5d%5d\n", $1, $2}' >> $resp

# find atomic number of molecule and write into .in file
n=`grep -n "POTENTIAL COMPUTED FOR" $1 | tail -1 | cut -d: -f1`
let n0=$n+$na
head -n $n0 $1 |tail -n $na |awk '{printf "%5d%5d\n", $2, 0}' >> $resp
echo 0 |awk '{printf "\n\n\n\n"}' >> $resp

# create .esp file for resp
# find points number and write data into .esp file 
npt=`grep "POINTS NPT=" $1 |tail -1`
npt=$(echo $npt |cut -d' ' -f7)
echo "$na $npt 0" | awk '{ printf "%5d%5d%5d\n",$1,$2,$3 }' > $esp
head -n $n0 $1 | tail -n $na | awk -v s=\  '{ printf "%16c%16.7e%16.7e%16.7e\n",s,$3,$4,$5 }' >>$esp

# write ELPOTT, x, y, z into .esp file
n=`grep -n "POINTS NPT=" $1 | tail -1 | cut -d: -f1`
let n1=$n+$npt
head -n $n1 $1 | tail -n $npt | awk '{ printf "%16.7e%16.7e%16.7e%16.7e\n",$5,$2,$3,$4}' >>$esp

# finish
echo "RESP files were created"
echo "Example of usage:"
echo -e "For first fitting without equivalence : \n\t resp -i $resp -e $esp -o ${file%.*}.out -p ${file%.*}.pch -t ${file%.*}.chg"

# Whether do second fitting 
file2=$2
file2suffix=${file2##*.}
if [[ $# == 2 && ${file2suffix} == "txt" ]];then
head -6 $resp > ${file%.*}2.in

# modify .in file for second fitting 
# add iqopt, that is, read in new initial charges from -q unit
sed -i 's/ihfree=1/&, iqopt=2/' ${file%.*}2.in

# atom number
head -n $n0 $1 |tail -n $na |awk '{printf "%5d\n", $2}' > tmp.in

# custom ivary for atom equivalence
cat *.txt |awk '{printf "%5d\n", $1}' > tmp2.in

# merge atom number and ivary and append *2.in file
paste tmp.in tmp2.in |awk '{printf "%5d%5d\n", $1, $2}' >> ${file%.*}2.in
echo 0 |awk '{printf "\n\n\n\n"}'  >> ${file%.*}2.in
rm -rf tmp.in tmp2.in

# finish
echo ""
echo -e "For second fitting with equivalence : \n\t resp -i ${file%.*}2.in -e $esp -q ${file%.*}.chg -o ${file%.*}2.out -p ${file%.*}2.pch -t ${file%.*}2.chg"
fi
