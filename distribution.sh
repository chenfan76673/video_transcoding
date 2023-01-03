time=`date +%y%m%d-%H:%M:%S`
file=$1
iptxt=$2
if [ -z $file ] 
then
        echo "没有找到要处理的文件列表文件"
        exit
fi
if [ -z $iptxt ] 
then
        echo "没有找到ip文件"
        exit
fi


base_dir=$(cd $(dirname $0);pwd)
machine_num=`cat $base_dir/$iptxt |wc -l`
file_num=`cat $base_dir/$file |wc -l`
echo "文件数量："$file_num  "机器数量："$machine_num

#每台机器要处理的文件个数
k=$((file_num / machine_num +1))
echo "每台机器要处理的文件个数:"$k
echo "正在分配中"
cp $base_dir/$file $base_dir/$file.bak
cat $base_dir/$file |shuf >$base_dir/$file-shuf.txt
for i in `cat $iptxt`;do cat $base_dir/$file-shuf.txt |head -n$k >$i;sed -i "1,${k}d" $base_dir/$file-shuf.txt;done
echo "分配完成"
