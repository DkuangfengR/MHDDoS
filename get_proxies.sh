#!/bin/bash

# fofa: body="get all proxy from proxy pool"
# 获取代理列表
function get_proxy_list {
  local url="http://42.192.20.108:5000/all/"
  local headers=(
    'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
    'Accept-Language: zh-CN,zh;q=0.9'
    'Cache-Control: no-cache'
    'Connection: keep-alive'
    'Pragma: no-cache'
    'Upgrade-Insecure-Requests: 1'
    'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  )

  # 执行 curl 命令并获取响应
  response=$(curl -s "$url" -H "${headers[@]}")

  # 使用 jq 解析 JSON 并提取代理列表
  response=$(echo "$response" | jq -r '.[] |.proxy')

  # 检查是否获取到了代理列表
  if [ -z "$response" ]; then
    echo "Failed to get proxy list."
    return 1
  fi

  # 将代理列表保存到文件中
  echo "$response" > files/proxies/http.txt

  # 返回成功状态
  return 0
}

# 检查代理是否有效
function check_proxy_validity {
  local url="http://www.baidu.com"
  local proxy_list_file="files/proxies/http.txt"

  while IFS= read -r proxy; do
    response=$(curl -s -o /dev/null -w "%{http_code}" -x "$proxy" "$url")
    
    if [ "$response" -eq 200 ]; then
      echo "Proxy $proxy is valid."
    fi
  done < "$proxy_list_file"
}

# 主程序
get_proxy_list
check_proxy_validity
