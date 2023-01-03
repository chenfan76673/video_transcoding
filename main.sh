ansible -i ip.txt all -m shell -a " bash /storage14/cf/video_transcoding/file_distribution/cp.sh" -f 100
ansible -i ip.txt all -m shell -a "bash /storage14/cf/video_transcoding/file_distribution/rename.sh " -f 100
ansible -i ip.txt all -m shell -a "bash /storage14/cf/video_transcoding/use_cpu_1115.sh " -f 200
