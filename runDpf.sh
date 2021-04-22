#!/bin/bash
 
for ligand in ../../lig_pdbqt/*.pdbqt; do
        ligandRen=`echo $ligand | cut -d'/' -f4 | cut -d'.' -f1 | cut -d'_' -f1`
	
	../../bin/prepare_dpf42.py -l ${ligand} -r 6ddf_clear_rigid.pdbqt -p flexres=6ddf_clear_flex.pdbqt -p move=../../lig_pdbqt/${ligandRen}_H.pdbqt -p set_ga=lga -p ga_num_evals=1000000 -p ga_pop_size=300 -p ga_run=100 -o 6ddf_${ligandRen}_flex.dpf
done
