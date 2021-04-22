#!/bin/bash
 
for arqDpf in ./*_flex.dpf; do
        arqDpfRen=`echo $arqDpf | cut -d'/' -f2 | cut -d'.' -f1`
	../../bin/autodock4 -p ${arqDpfRen}.dpf -l ${arqDpfRen}.dlg
done
