#!/bin/bash

getdir(){
	if [ -z $1 ];then
		echo "无可用参数，退出" >&2
		kill -9 $$
		exit 1
	fi
        find $1 -type f -printf "%AY%Aj%AH%AM%AS %h/%f\n" | grep -E -i '\.jpg|\.png|\.jpeg' | sort -n | cut -f2 -d' '
}
killme(){
	echo "进程被终止"
	kill -9 $$
}
about(){
	echo -e "用法：$0 -d <图片所在目录> [-s] [-o <输出文件>]"
	echo -e "各参数解释：\n"
	echo -e "  -d | --directory : 该参数用于指定图片所在目录，也可在所有参数都缺省的情况下省略该参数，直接后接图片目录"
	echo -e "  -s | --show      : 该参数用于显示已识别出的结果"
	echo -e "  -o | --output    : 该参数用于指定识别结果输出位置，若其后为文件夹，则以图片文件名输出，若其后为文件，则统一输出至此文件，若其后值为空，则将以图片名输出到原目录，若该参数缺省，则以output.txt输出到原目录"
	echo -e "  -h | --help      : 打印本帮助\n"
	echo -e "本脚本由stackzhao<stackzhao@gmail.com>开发\n\n"
	exit 0
}
trap "killme" 2
ARGS=`getopt -o 'hsd:o::' -l 'help,show,directory:output::' -n $(basename $BASH_SOURCE) -q -- "$@"`
if [ $? != 0 ]; then
    echo "$* 错误的参数"
    about
    echo "退出..."
    exit 1
fi
eval set -- "${ARGS}"

while :
do
    case "$1" in
        -d|--directory)
	if [[ -z ${2} ]];then
        	echo '无参数，退出！'
	        exit 1
	elif [[ ! -d ${2} ]];then
        	echo '参数不是一个可执行的目录'
	        exit 1
	fi
	imgdir=${2}
	shift 2
	;;
	-o|--output)
	case "$2" in
                "")
                    output=yes;
                    shift 2  
                    ;;
                *)
                    outfile=$2;
                    shift 2;
                    ;;
        esac
	;;
	-s|--show)
	filechange=1
	shift
        ;;
	-h|--help)
	about
	shift
	;;
        --)
            shift
            break
            ;;
        *)
            echo "传入错误!"
            exit 1
            ;;
    esac
done

for arg in $@
do
	if [[ ! -z ${arg} && -d ${arg} ]];then
		imgdir=${arg}
		break
	fi
done

echo "开始处理图片,共$(getdir ${imgdir}|wc -l)张"
num=1
for img in $(getdir ${imgdir})
do
	file="${img}"
	filename=$(basename ${file})
	filedir=$(dirname ${file})
	unfilename=${filename%%.*}
	if [[ ${output} == yes ]]; then
		outputfile="${filedir}/${unfilename}.txt"
	elif [[ -d ${outfile} ]]; then
		outfile=${outfile%%\/}
		outputfile="${outfile}/${unfilename}.txt"
		if [[ -f ${outputfile} ]];then
			rm -f ${outputfile}
		fi
	elif [[ -z ${output} && -z ${outfile} ]]; then
		outputfile="${filedir}/output.txt"
		if [[ ${num} == 1 ]];then
			find ${imgdir} -name 'output.txt' | xargs rm -rf
		fi
	else
		outputfile=${outfile}
		if [[ ${num} == 1 && -a ${outputfile} ]];then
			rm -f ${outputfile}
		fi
	fi
	echo "第${num}张 → ${filename}"
	check=0
	ff=1
	while [[ $check == 0 ]];do
		python3 ${PWD}/baidu_OCR.py -i ${file} > /tmp/.ocr.cache 2>/dev/null
		cat /tmp/.ocr.cache >> ${outputfile}
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
				echo -e "\n！！本段识别失败！！\n" >> ${outputfile}
			fi
			ff=$((ff + 1))
		else
			num=$((num + 1))
			sed -i '${/^[0-9]\+$/d}' ${outputfile}
			if [[ ${filechange} == 1 ]] ;then
				echo -e "\n=====识别结果====="
				cat /tmp/.ocr.cache
				echo -e "\n=====The END=====\n"
			else
				echo -e "成功\n"
			fi
			check=1
		fi
	done
done
echo "全部完成，退出"
exit 0
