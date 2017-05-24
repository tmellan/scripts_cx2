#!/bin/bash



#Run a set of calculations, same as *_fresh, but increased ENCUT and ediff
#Input: INCAR, KPOINTS, POSCAR, POTCAR, and run.pbs from folder ./sub_stuff
#Variables: folder names, kpoints value in KPOINTS, directory address and run name in run.pbs

#Note - double quotes needed to pass variable to sed in cx2

#######################################################
#The parallel pbs run file:

#!/bin/sh
#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=12:mpiprocs=12:mem=12Gb
#PBS -N 17fresh

#module load intel-suite/2016.3
#module load mpi/mpt-2.14
#module load vasp/5.4.1-wannier
#module load wannier90/2.1.0

#cd /scratch/tmellan/boltzWann/2clean_wannier/xxDIRxx
#mpiexec_mpt -n 12  vasp_std  
#wait

#mpiexec_mpt -n 12 wannier90.x wannier90
#wait

#cat cond_stuff wannier90.win > tmp ; mv tmp wannier90.win
#mpiexec_mpt -n 12 postw90.x wannier90
#wait

#echo done!
##########################################################

hdir=`pwd`
#Define the kpoints to test
list="5 10 15 20 25 30 35 39"

for i in $list; do 
  kp=$(echo $i $i $i)

#mk job dir and cp run stuff there
  rm -r $i 
  mkdir $i
  cd $i 
  cp ../sub_stuff/* .

#modify run stuff - set kpoints to iteration
  sed -i "s/xxDIRxx/$i/g" run.pbs
  sed -i "s/xxNAMExx/$i$i$i/g" run.pbs
  sed -i "s/xxKPxx/$kp/g" KPOINTS 

#submit all at once to short queue
  qsub run.pbs

#return home
  cd $hdir

done

