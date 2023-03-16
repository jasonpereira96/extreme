i=1
for exp in 20
do
    for P in 1
    do
        echo "${i}. exp: ${exp} P: 1  ppn: ${P}"
        qsub -l nodes=1:ppn=$P -v exp="$exp",P="1",ppn="$P" run.sh
        i=$((i+1))

        echo "${i}. exp: ${exp} P: ${P} ppn: 1"
        qsub -l nodes=$P:ppn=1 -v exp="$exp",P="$P",ppn="1" run.sh
        i=$((i+1))
    done
done


# qsub -l nodes=$P:ppn=$ppn -v exp="$exp",P="$P"  run.sh