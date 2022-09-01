#!/bin/bash


#--------------[ data_nCluster.txt ]-----------------------------
#--- Frame | IUA | nCluster | dist_165_279 | rmsd_NPxxYA
#--- X		X	X	X		x
#----------------------------------------------------------------

i="data_nCluster.txt" 

while read j
do
	nCluster=$(echo $j | awk '{print $3}')  #Captura o valor nCluster.
	#echo $nCluster

	if [ $nCluster -eq 3 ] ; then		#Busca dos valores de um cluster específico.
		echo $j >> data_cluster3.txt
	fi

done < $i
