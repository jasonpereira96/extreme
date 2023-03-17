rm par_pi_op_jason.txt
rm temp.txt
make clean
make all
i=1
SLEEP_TIME=5
for exp in 20 23 26
do
    for P in 1 2 4 8
    do
        echo "${i}. exp: ${exp} P: 1  ppn: ${P}"
        qsub -l nodes=1:ppn=$P -v exp="$exp",P="1",ppn="$P",id="$i",groupId="$exp-1-P" run.sh
        i=$((i+1))
        sleep $SLEEP_TIME

        echo "${i}. exp: ${exp} P: ${P} ppn: 1"
        qsub -l nodes=$P:ppn=1 -v exp="$exp",P="$P",ppn="1",id="$i",groupId="$exp-P-1" run.sh
        i=$((i+1))
        sleep $SLEEP_TIME
    done

    echo "${i}. exp: ${exp} P: 1  ppn: 16"
    qsub -l nodes=1:ppn=16 -v exp="$exp",P="1",ppn="16",id="$i",groupId="$exp-1-P" run.sh
    i=$((i+1))
    sleep $SLEEP_TIME

    echo "${i}. exp: ${exp} P: 8 ppn: 2"
    qsub -l nodes=8:ppn=2 -v exp="$exp",P="8",ppn="2",id="$i",groupId="$exp-P-1" run.sh
    i=$((i+1))
    sleep $SLEEP_TIME

    i=1
    sleep $SLEEP_TIME
    sleep $SLEEP_TIME
    rm temp.txt
done

# qsub -l nodes=$P:ppn=$ppn -v exp="$exp",P="$P"  run.sh