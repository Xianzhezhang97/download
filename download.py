import requests
import pdfkit

# 定义颜色列表
EmphasizeColorLists = [
    "red",
    "orange",
    "yellow",
    "lime",
    "sky",
    "blue",
    "purple",
]

# 遍历ID从0到6
for index in range(7):
    url = f"http://localhost:3000/resume/{index}"
    response = requests.get(url)
    if response.status_code == 200:
        # 指定PDF文件名
        color = EmphasizeColorLists[index]
        filename = f"Xianzhe's_CV_{color}.pdf"
        
        # 使用pdfkit将HTML内容转换为PDF
        pdfkit.from_string(response.text, filename)
        print(f"Saved: {filename}")
    else:
        print(f"Failed to fetch {url}")
