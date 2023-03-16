rm log.txt
i=1
for exp in 20
do
    for P in 1 2 4 8
    do
        echo "${i}. exp: ${exp} P: 1  ppn: ${P}"
        qsub -l nodes=1:ppn=$P -v exp="$exp",P="1",ppn="$P",id="$i" run.sh
        i=$((i+1))

        echo "${i}. exp: ${exp} P: ${P} ppn: 1"
        qsub -l nodes=$P:ppn=1 -v exp="$exp",P="$P",ppn="1",id="$i" run.sh
        i=$((i+1))
    done
done


for exp in 20
do
    for P in 16
    do
        echo "${i}. exp: ${exp} P: 1  ppn: ${P}"
        qsub -l nodes=1:ppn=$P -v exp="$exp",P="1",ppn="$P",id="$i" run.sh
        i=$((i+1))

        echo "${i}. exp: ${exp} P: 8 ppn: 2"
        qsub -l nodes=8:ppn=2 -v exp="$exp",P="8",ppn="2",id="$i" run.sh
        i=$((i+1))
    done
done


# qsub -l nodes=$P:ppn=$ppn -v exp="$exp",P="$P"  run.sh