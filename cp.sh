time=`date +%y%m%d-%H:%M:%S`
IP=`hostname -I`
rm -f /data/input/*

cp /storage14/cf/video_transcoding/file_distribution/${IP} /data/file.txt

IFS_BACK=$IFS
IFS=$(echo -en "\n\b")
for i in `cat /data/file.txt`
do
        #cp -av /storage13/${Projext_name}_downloaddata_chuli/"$i" /data/input/ >> /data/${time}.log
        cp -av /storage-f0155049-14/real_data/jy/download_video/idc/"$i" /data/input/ >> /data/${time}.log
done
IFS=$IFS_BACK
