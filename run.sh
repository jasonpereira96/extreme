#!/bin/bash
#PBS -N pi_jason
#PBS -l walltime=00:00:15
#PBS -l nodes=2:ppn=4
#PBS -q edu_shared
#PBS -j oe
#
## Move to the directory where the job was submitted
#
cd $PBS_O_WORKDIR
#
#  setup MPI programming environment
#
module load MPICH/3.3.2-GCC-9.3.0
#
# Build mpi job
#
# No need to build
#
# Run mpi job
#
# mpirun -np $PBS_NP ./pi_jason
mpirun ./par_pi_jason $exp $P $ppn $id $groupId

