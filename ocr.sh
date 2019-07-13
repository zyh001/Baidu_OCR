#!/bin/bash

getdir(){
        find $1 -type f -printf "%AY%Aj%AH%AM%AS %h/%f\n" | sort -n | cut -f2 -d' ' | grep -E -i '.jpg|.png|.jpeg'
}
if [[ -z ${1} ]];then
	echo '无参数，退出！'
	exit 1
elif [[ -f ${1} ]];then
	python3 ${PWD}/plus_baidu_OCR.py -i ${@}
	exit 0
elif [[ ! -d ${1} ]];then
	echo '参数不是一个可执行的目录'
	exit 1
fi
imgdir=${1}
echo "开始处理图片,共$(getdir ${imgdir}|wc -l)张"
num=1
find ${imgdir} -name 'output.txt' | xargs rm -rf
for img in $(getdir ${imgdir})
do
	file="${img}"
	filename=$(basename ${file})
	filedir=$(dirname ${file})
	echo "第${num}张 → ${filename}"
	check=0
	ff=1
	while [[ $check == 0 ]];do
		python3 ${PWD}/baidu_OCR.py -i ${file} >> ${filedir}/output.txt
		if [[ $? != 0 ]];then
			echo '失败，重新尝试'
			echo -e "第${ff}次\n"
			if [[ ${ff} == 3 ]];then
				check=1
				echo '识别失败，跳过'
	                        if [[ $(du $file -s | awk '{ print $1}') -ge 4000 ]];then
        	                        echo '这可能是由于文件过大所导致的，建议对图片进行压缩后再次尝试'
				else
					echo '图片可能已经损坏，或者图片中不存在文字'
	
                        	fi
				echo '
！！本段识别失败！！
' >> ${filedir}/output.txt
			fi
			ff=$((ff + 1))
		else
			num=$((num + 1))
			sed -i '${/^[0-9]\+$/d}' ${filedir}/output.txt
			echo '成功
'
			check=1
		fi
	done
done
echo "全部完成，退出"
exit 0
