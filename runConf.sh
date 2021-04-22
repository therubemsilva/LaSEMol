
for ligand in ../../../lig_pdbqt/*.pdbqt; do

ligandRen=`echo $ligand | cut -d'/' -f5 | cut -d'.' -f1 | cut -d'_' -f1`

echo 'receptor= 4dkl_clear_rigid.pdbqt
ligand= '$ligand'

center_x= -27.997
center_y= -13.204
center_z= -11.084

size_x= 23
size_y= 23
size_z= 26

out= 4dkl_'$ligandRen'_flex_vina.pdbqt
log= 4dkl_'$ligandRen'_flex_vina.txt

exhaustiveness= 8' > conf_${ligandRen}_flex.txt

done
