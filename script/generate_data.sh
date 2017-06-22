#!/bin/bash

binName=$(which bulk_data_gen)
binVersion=`md5sum $binName | awk '{ print $1 }'`
dataDir=${dataDir:-/disk/1/bulk_data}

formats=${formats:-"timescaledb"}
scaleVar=${scaleVar:-"1000"}
seed=${seed:-"123"}
tsStart=${tsStart:-"2016-01-01T00:00:00Z"}
tsEnd=${tsEnd:-"2016-01-11T00:00:00Z"}
useCase=${useCase:-"cpu-only"}

mkdir -p ${dataDir}

pushd ${dataDir}

for format in "${formats[@]}"
do
    fname="import_${format}_${binVersion}_${scaleVar}_${seed}_${tsStart}_${tsEnd}_${useCase}.dat.gz"
    echo "$fname"
    if [ ! -f "$fname" ]; then
        $binName -format $format -scale-var $scaleVar -seed $seed -timestamp-end $tsEnd -timestamp-start $tsStart -use-case $useCase | gzip > $fname
        ln -s $fname ${format}-data.gz
    fi
   # or do whatever with individual element of the array
done


  # -format string
  #   	Format to emit. (choices: influx-bulk, es-bulk, cassandra, timescaledb) (default "influx-bulk")
  # -logSeconds duration
  #   	duration between host data points (default 10s)
  # -scale-var int
  #   	Scaling variable specific to the use case. (default 1)
  # -seed int
  #   	PRNG seed (default, or 0, uses the current timestamp).
  # -timestamp-end string
  #   	Ending timestamp (RFC3339). (default "2016-01-02T06:00:00Z")
  # -timestamp-start string
  #   	Beginning timestamp (RFC3339). (default "2016-01-01T00:00:00Z")
  # -use-case string
  #   	Use case to model. (choices: devops, iot) (default "devops")