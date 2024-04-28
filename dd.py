import os
import requests
from bs4 import BeautifulSoup

def download_webpages(urls, target_dir):
    # 创建目标目录
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    # 逐个下载网页
    for url in urls:
        try:
            # 发送 HTTP 请求并获取响应内容
            response = requests.get(url)
            
            # 检查响应状态码
            if response.status_code == 200:
                # 从 URL 中提取文件名
                filename =  url.split("/")[-2]  # 使用最后一部分作为文件名
                # 去除参数部分
                filename = filename.split('?')[0]
                filename = filename+'.pdf'
                # 构造目标文件路径
                filepath = os.path.join(target_dir, filename)

                # 写入响应内容到文件中
                with open(filepath, "wb") as f:
                    f.write(response.content)

                print(f"网页 {url} 下载成功")

                # 解析 HTML 文件并提取图片 URL
                soup = BeautifulSoup(response.content, "html.parser")
                img_urls = [img["src"] for img in soup.find_all("img")]

                # 下载图片
                for img_url in img_urls:
                    # 拼接图片文件名
                    img_filename = img_url.split("/")[-1]

                    # 下载图片
                    response = requests.get(img_url)
                    with open(os.path.join(target_dir, img_filename), "wb") as f:
                        f.write(response.content)

                    print(f"图片 {img_filename} 下载成功")
            else:
                print(f"网页 {url} 下载失败，状态码：{response.status_code}")
        except Exception as e:
            print(f"下载网页 {url} 时出现异常：{str(e)}")

if __name__ == "__main__":
    # 定义要下载的网页 URL 列表
    urls = []
    # 定义要下载的文件 URL 列表
    for i in range(0, 7):
        # 拼接 URL
        url = f"http://localhost:3000/resume/{i}" # 1-9 exercise
        # url = f'https://cgi.cse.unsw.edu.au/~cs9315/24T1/pracs/p{i:02}/index.php' # 1-9 prac exercise
        # url1 = f'https://cgi.cse.unsw.edu.au/~cs9315/24T1/lectures/week{i:02}-monday/slides.html'  # 1-9 9315
        # url2 = f'https://www.cse.unsw.edu.au/~cs9315/24T1/lectures/w{i:02}t/slides.html' # 1-9 9315

        urls.append(url)
        # urls.append(url2)

    # 定义目标目录
    target_dir = "/Users/xianzhezhang/Desktop/CV"

    # 调用函数进行下载
    download_webpages(urls, target_dir)
