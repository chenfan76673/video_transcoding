import os
import sys


print("当前路径: ",os.getcwd())
image_path = sys.argv[1]
for filename in os.listdir(image_path):
    newName = str(filename)
    newName = newName.replace(' ', '') #此处可以自行修改变成去除空格or去除逗号等等
    os.rename(os.path.join(image_path,filename),os.path.join(image_path,newName))
    print("文件： ",filename,"——>",newName," 重命名已完成！")
