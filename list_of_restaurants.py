import urllib.request
from bs4 import BeautifulSoup

with urllib.request.urlopen("http://www.yelp.com/search?find_desc=&find_loc=92111&ns=1") as url:
    s = url.read().decode('utf-8', 'ignore')
    #t = s.encode('gbk', 'ignore')

soup = BeautifulSoup(s, 'html.parser')

summary = []

for line in soup.find_all('h3'):#(attrs={"class": "indexed-biz-name"}):
    arr = str.split(line.text.encode('gbk', 'ignore').decode('gbk'))
    for i in arr:
        if i == '': 
            arr.remove(i)
    print(arr)
    #line2 = line.text.encode('gbk', 'ignore')
    summary.append(arr)               

"""
info = [i for i in summary]
for i in info:
	print(i)
"""