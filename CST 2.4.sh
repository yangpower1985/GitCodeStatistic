#!/bin/bash

code_path="//Mac/Home/Documents/code/"
project_name=(smart-project smart-project-ucd smart-app smart-auto-test smart-cas smart-common-lib smart-dw smart-dw-ucd smart-file-service smart-home smart-home-ucd smart-oauth2-server smart-platform smart-platform-ucd smart-sales smart-sales-ucd smart-supply-chain smart-supply-chain-ucd smart-task smart-tower smart-tower-ucd smart-eureka-server)
output_filepath="//Mac/Home/Documents/code/"
prjNum=${#project_name[@]}

downloadCode(){ #${project_name},${code_path}

	user="yangbowen"
	pwd="heqin168"
	ip="10.6.21.160:5116/Smart-Studio/"

	rm -rf $2$1

	cd $2
	git clone -b release http://${user}:${pwd}@${ip}$1.git
}

fun_CST_OneProjectOneTime() {
	
	echo ">>> one project one time statistic: step2.1 >>>"$*
	rm -rf $3
	git fetch --all
	git pull --all
	
	echo ">>> one project one time statistic: step2.2 >>>"
	git branch -r | grep -v '\->' | while read remote; do git branch -D "${remote#origin/}"; git branch --track "${remote#origin/}" "$remote"; done
	
	echo ">>> one project one time statistic: step2.3 >>>"
	git branch -r | grep -v '\->' | while read remote; do git checkout "${remote#origin/}";git pull;git log --since=$1 --until=$2 --format='%aN' | sort -u | while read name; do echo -en "${remote#origin/}," "$name,"; git log --since=$1 --until=$2 --author="$name" --numstat --pretty=tformat: --no-merges | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines, %s, removed lines, %s, total lines, %s\n", add, subs, loc }' -; done >> $3; done

	echo ">>> one project one time statistic: step2.4 >>>"
	git checkout release
}

fun_CST_OnePrj() {
	idx=(0 1 2)
	start_date=("2018-9-1" "2018-10-1" "2018-11-1")
	end_date=("2018-9-30" "2018-10-31" "2018-11-30")
	timeNum=${#idx[@]}

	echo ">>> fun_CST_OnePrj: "$*
	curTimeNum=1
	for var in ${idx[@]}
	do
		echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo ">>> one prject statistic: ${curTimeNum}/${timeNum}>>>"$var
		fun_CST_OneProjectOneTime ${start_date[$var]} ${end_date[$var]} $1"_"${start_date[$var]}"_"${end_date[$var]}".csv"
		curTimeNum=$(($curTimeNum+1))
	done
}

curPrjNum=1
for var in ${project_name[@]}
do
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo ">>> statistic: ${curPrjNum}/${prjNum}>>>"$var
	
	echo ">>> step1: download code>>>"
	#download code according to the parameter
	if(( $1>0 ))
	then
		downloadCode $var $code_path
	fi
	
	echo ">>> step2: statistic code>>>"
	cd $var
	fun_CST_OnePrj ${output_filepath}"CST_"$var
	cd ..

	curPrjNum=$(($curPrjNum+1))
done





