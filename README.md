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
`ocr.sh`参数详解：
```
#./ocr.sh --help
用法：./ocr.sh -d <图片所在目录> [-s] [-o <输出文件>]
各参数解释：

  -d | directory : 该参数用于指定图片所在目录，也可在所有参 数都缺省的情况下省略该参数，直接后接图片目录
  -s | --show    : 该参数用于显示已识别出的结果
  -o | --output  : 该参数用于指定识别结果输出位置，若其后为 文件夹，则以图片文件名输出，若其后为文件，则统一输出至此文件，若其后值为空，则将以图片名输出到原目录，若该参数缺省，则o utput.txt输出到原目录
  -h | --help    : 打印本帮助

本脚本由stackzhao<stackzhao@gmail.com>开发
```
