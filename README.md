# Baidu_OCR 工程
这是一个利用Baidu开放api平台开发的通用文字识别脚本,本脚本依赖于Baidu-AIP包，在使用之前请先`pip3 install baidu-aip`

此处省略api申请步骤，可访问[http://ai.baidu.com/tech/ocr](http://ai.baidu.com/tech/ocr)进行申请

拿到API Key和Secret Key后执行`git clone https://github.com/zyh001/Baidu_OCR.git && cd Baidu_OCR && python3 ./baidu_OCR.py --init`按提示操作

操作示例：
```
#图像文件请勿大于4M，将会导致识别失败
#单个文件识别
python3 ./baidu_OCR.py -i 1.jpg

#单个文件识别，输出到文件
python3 ./baidu_OCR.py -i 1.jpg -o ./output.txt

#多文件识别
python3 ./plus_baidu_OCR.py -i 1.jpg 2.jpg 3.jpg

#多文件识别，输出到文件
python3 ./plus_baidu_OCR.py -i 1.jpg 2.jpg 3.jpg -o output.txt

#文件夹递归操作，按图像创建时间，识别文字并自动输出到文件
bash ./ocr.sh ./TestDir
```
