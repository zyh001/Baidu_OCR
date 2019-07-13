#!/usr/bin/env python3
##this script is developed by lunarjoll and publish in git@github.com:lunarjoll/baidu_OCR.git
##sent Email to me :    lunarkindle@yahoo.com
import requests, sys, getopt, configparser, timeit, argparse
from aip import AipOcr
start = timeit.default_timer()
#pip3 install baidu-aip aip?
input_file=None
output_file=None
# 定义参数变量
options = {
  'detect_direction': 'true',
  'language_type': 'CHN_ENG',
}

def read_config():
    config = configparser.ConfigParser()
    config.read("baidu_OCR.conf")
    client = AipOcr(config["baidu"]["APP_ID"], config["baidu"]["API_KEY"], config["baidu"]["SECRET_KEY"])
    return client



def create_config():
    print("go to baidu and create APP_ID. \n\
            https://console.bce.baidu.com ")
    config = configparser.ConfigParser()
    config['baidu'] = {}
    config['baidu']['APP_ID'] = input("APP_ID=");
    config['baidu']['API_KEY'] = input("API_KEY=");
    config['baidu']['SECRET_KEY'] = input("SECRET_KEY=");
    with open('baidu_OCR.conf', 'w') as configfile:
        config.write(configfile)
        configfile.close()




def usage():
    print("     when first use, go to baidu and create APP_ID. \n\
            and pip3 install baidu-aip \n\
            and use --init to create config file \n\
            https://console.bce.baidu.com \n")
    print (sys.argv[0], '--init')
    print (sys.argv[0], '-i <inputfile> -o <outputfile>')
    return 0



# 读取图片
def get_file_content(input_file):
    image_file = None
    try:
        if input_file.startswith('http://') or input_file.startswith('https://'):
            return requests.get(input_file).content
            #return image_file
        else:
            with open(input_file, 'rb') as fp:
                return fp.read()
    except Exception:
        raise Exception('invalid input_file: %s' % input_file)




# 调用通用文字识别接口

def baidu_link(input_file, output_file, client, options):
    result = client.basicAccurate(get_file_content(input_file), options)
    #print(result)
    words_result=result['words_result']
    if output_file == None:
        for i in range(len(words_result)):
            print(words_result[i]['words'])
        print("\n\n")
    else:
        fo = open(output_file,"a")
        for i in range(len(words_result)):
            fo.write(words_result[i]['words'] + "\n")
        fo.write("\n\n")
        fo.close()
        end=timeit.default_timer()
        print('Running time: %s Seconds'%(end-start))


def main ():
    parser = argparse.ArgumentParser(description='OCR program, Optical Character Recognition, jpg2txt')
    parser.add_argument('-i', '--ifile', nargs='+', help='-i input_file or http_url', dest='input_file')
    parser.add_argument('-o', dest='output_file', default=None)

    args = parser.parse_args()
    #client = read_config()

    output_file = args.output_file
    for file in args.input_file:
        baidu_link(file, output_file, read_config(), options)

''' #this is getopt
try:
    opts, args = getopt.getopt(sys.argv[1:], "hi:o:", ["verbose", "version", "ifile=", "init"])
except getopt.GetoptError:
    print (sys.argv[0], 'GetoptError' ),
    sys.exit(2)
for op, value in opts:
    if op in ("-i", "--ifile"):
        input_file = value
    elif op == "-o":
        output_file = value
    elif op == "-h":
        usage()
        sys.exit()
    elif op == "--init":
        create_config()
        sys.exit()
if input_file == None:
    usage()
    sys.exit(2)
'''        
        



#input_file = 'https://imgsa.baidu.com/forum/pic/item/c0d66dcb39dbb6fdfb44797a0424ab18972b3758.jpg'
##client  = AipOcr(APP_ID, API_KEY, SECRET_KEY)
#config = configparser.ConfigParser()
#config.read("baidu_OCR.conf")
#client = AipOcr(config["baidu"]["APP_ID"], config["baidu"]["API_KEY"], config["baidu"]["SECRET_KEY"])
#
#baidu_link(input_file, output_file, options)




if __name__ == "__main__":
        main()

'''
if resp is not None:
    resp = resp.json()
    if int(resp.get('errNum')) != 0:
        raise Exception(reps.get('errMsg'))
    else:
        return resp.get('words_result')[0].get('word')
else:
    return None
#print(result)
'''



##this script is developed by lunarjoll and publish in git@github.com:lunarjoll/baidu_OCR.git
##sent Email to me :    lunarkindle@yahoo.com
