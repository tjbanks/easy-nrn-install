#!/bin/bash -x
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --time=00:15:00
#SBATCH --partition=knl
module load intel-ics intel-impi
export KMP_AFFINITY=SCATTER
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
srun ./mpi-prog
