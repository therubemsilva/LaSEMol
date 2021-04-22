

for aConf in ./conf_*_flex.txt; do
	aConfRen=`echo $aConf | cut -d'.' -f2 | cut -d'_' -f2`
	echo $aConfRen
	vina --config $aConf --receptor 4dkl_clear_rigid.pdbqt --flex 4dkl_clear_flex.pdbqt --ligand ../../../lig_pdbqt/${aConfRen}*.pdbqt
done
