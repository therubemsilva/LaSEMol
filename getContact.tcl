for {set id 0} {$id < 13} {incr id} { 
set frames [molinfo $id get numframes] 
set fnum [open $id\_contact_num_2.txt w] 
set fnam [open $id\_contact_nam_2.txt w] 
for {set i 1} {$i < $frames} {incr i} { 
                puts "Frame: $i" 
                set cont [atomselect $id "(same residue as within 5 of (not protein and not lipids and not ions and not water and not resid 352)) and not water"] 
                $cont frame $i 
                $cont update 
                set num [lsort -uniq [$cont get resid]] 
                set nam [lsort -uniq [$cont get resname]] 
                puts $fnum "$i $num" 
                puts $fnam "$i $nam" 
                $cont delete 
} 
close $fnum 
close $fnam 
}
