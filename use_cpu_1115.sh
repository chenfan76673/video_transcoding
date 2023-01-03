#!/bin/bash
max_proc=3
max_thread=8
malv=100k
. /storage14/cf/video_transcoding/file_distribution/config.sh
base_path=$(cd `dirname $0`; pwd)
input_path=/data/input
output_path=/data/output
#output_path=/storage-f0155049-14/real_data/cf/${Projext_name}_srcdata
#ratio指分辨率，可选项有2k,480,720,1080
[ -d $output_path ] || mkdir $output_path


function token_333()
{
    [ -e /tmp/fd3 ] || mkfifo /tmp/fd3
    exec 333<>/tmp/fd3
    rm -rf /tmp/fd3
    for ((i=1;i<=$max_proc;i++)); do
        echo >&333
    done
}

function use_cpu()
{
    
    if [ $1 == "480"  ];then scale="720*480";fsize=-900M;fi
    if [ $1 == "720"  ];then scale="1280*720";fsize=-500M;fi
    if [ $1 == "1080"  ];then scale="1920*1080";fsize=-250M;fi
    if [ $1 == "2k"  ];then scale="2560*1440";fsize=-100M;fi
    if [ $1 == "4k"  ];then scale="3840*2160";fsize=-100M;fi
    for input_file in $(find $input_path -name "*.mp4" -type f -size $fsize); do
        read -u333
        {
            start=$(date +%s)
            start_time=$(date +%Y%m%d%H%M%S)
            if [ ! -f $output_path/${ratio}_${input_file##*/} ]; then
                        ffmpeg -i "$input_file" -vf scale=${scale}:flags=lanczos -c:v libx264 -threads $max_thread -strict -2 -preset slow -crf 0 -b:v $malv -y "$output_path/${1}_${input_file##*/}"
                        if [ $? -eq 0 ]; then
                                is_file=success
                        else
                                is_file=failure
                        fi
            else
                is_file=created
            fi
            end=$(date +%s)
            end_time=$(date +%Y%m%d%H%M%S)
            use_time=$[ $end - $start ]
            echo "{\"start_time\": \"$start_time\", \"end_time\": \"$end_time\", \"use_time\": \"$use_time\", \"input_file\": \"$input_file\", \"output_file\": \"$output_path/${input_file##*/}\", \"is_file\": \"$is_file\"}"
            echo >&333
        } &
    done
}

function main()
{
    total_start=$(date +%s)
    total_start_time=$(date +%Y%m%d%H%M%S)
    token_333
    use_cpu 480
    use_cpu 720
    use_cpu 1080
    use_cpu 2k
    use_cpu 4k
    wait
    exec 333<&-
    exec 333>&-
    total_end=$(date +%s)
    total_end_time=$(date +%Y%m%d%H%M%S)
    total_use_time=$[ $total_end - $total_start ]
    echo "{\"total_start_time\": \"$total_start_time\", \"total_end_time\": \"$total_end_time\", \"total_use_time\": \"$total_use_time\"}"
}


ffm_num=`ps -ef|grep ffmpeg |grep -v grep |wc -l`
if [ $ffm_num -eq 0 ]
then
        IFS_BACK=$IFS
        IFS=$(echo -en "\n\b")
        main >use_cpu_$(date +%Y%m%d%H%M%S).log
        IFS=$IFS_BACK
else
        echo "程序已经跑起来了，不要重复跑。"

fi
