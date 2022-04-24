#!/bin/bash

assoc=8
benchmarks=("mcf" "libquantum" "a2time01" "cacheb01" "bitmnp01")

# MINOR WITH PARTITION
mkdir -p ./project_stats/minorCPU_8way
for ((i=0; i < ${#benchmarks[@]}; i++))
do
  mkdir -p ./project_stats/minorCPU_8way/${benchmarks[$i]}
  for ((j=0; j < ${#benchmarks[@]}; j++))
  do
    if [[ ${benchmarks[$i]} == ${benchmarks[$j]} ]]; then
      continue # use break to reduce repetitive simulation runs
    fi

    for ((partition=1; partition < $assoc; partition++))
    do
    build/ARM/gem5.opt \
    --stats-file=../project_stats/minorCPU_8way/${benchmarks[$i]}/stats_${benchmarks[$i]}_${benchmarks[$j]}_${partition}.txt \
    --debug-flags=CacheRepl configs/example/se.py \
    --cpu-type=MinorCPU --bench=mcf-${benchmarks[$j]} -n 2 -I 1000000 --caches \
    --l2cache --l2_assoc=${assoc} --div_ptr=${partition}
    done
  done
done

# MINOR NO PARTITION
mkdir -p ./project_stats/no_partition_minorCPU_8way
for ((i=0; i < ${#benchmarks[@]}; i++))
do
  mkdir -p ./project_stats/no_partition_minorCPU_8way/${benchmarks[$i]}
  for ((j=0; j < ${#benchmarks[@]}; j++))
  do
    if [[ ${benchmarks[$i]} == ${benchmarks[$j]} ]]; then
      continue # use break to reduce repetitive simulation runs
    fi

    build/ARM/gem5.opt \
    --stats-file=../project_stats/no_partition_minorCPU_8way/${benchmarks[$i]}/stats_${benchmarks[$i]}_${benchmarks[$j]}.txt \
    --debug-flags=CacheRepl configs/example/se.py \
    --cpu-type=MinorCPU --bench=mcf-${benchmarks[$j]} -n 2 -I 1000000 --caches \
    --l2cache --l2_assoc=${assoc}
  done
done
