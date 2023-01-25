#!/bin/bash

#creat all replic

for count in {1..54}; do		#numero de replicas

	val=$((count-1))
	name=md_${val}
	echo "gmx grompp -f ../mdp_replic/${name}/md.mdp \
	-c *_NPT.gro \
	-r *_NPT.gro \
	-p ../top/system.top \
	-n centerOfMass.ndx \
	-o ../mdp_replic/${name}/md.tpr"

done

