#!/bin/bash 


for arqPDB in ./*.pdb; do					# para todo arquivo 	'trjconv00000000000XXXXX.pdb'
	arqName=`echo $arqPDB | cut -d'/' -f2 | cut -d'.' -f1`  # atribuie o valor 	'trjconv00000000000XXXXX'
	getFrame=`echo $arqName | cut -c 19-23`			# atribuie o valor 	'XXXXX'
	
	getIUA=`python activation_index.py -structure $arqPDB -chain A -muscle ./muscle3.8.31_i86linux64 -TM1_50 86 -TM2_50 114 -TM3_50 165 -TM4_50 192 -TM5_50 244 -TM6_50 295 -TM7_50 333 | awk '{print $6}'`
        
	echo ${getFrame}$'\t'${getIUA} >> FRAME_IUA_K44.dat	# output FRAME IUA, ($'\t') tabulação
done

