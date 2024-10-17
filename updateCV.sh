#!/bin/bash

# 指定输入和输出文件
input_file="CV | Oringinal.pages"
output_file="CV | Scott Cheung.pdf"

# 检查 Pages 文件是否存在
if [ ! -f "$input_file" ]; then
  echo "输入文件不存在: $input_file"
  exit 1
fi

# 使用 AppleScript 将 pages 文件转为 pdf
osascript <<EOF
on run
    tell application "Pages"
        open (POSIX file "$PWD/$input_file")
        set outputFile to POSIX file "$PWD/$output_file"
        export front document to outputFile as PDF
        close front document
    end tell
end run
EOF

# 检查输出文件是否成功生成
if [ -f "$output_file" ]; then
  git add .
  git commit -m "Update CV | Scott Update | $(date) | $(hostname)"
  git push
  echo "转换成功，已更新到服务器! ===> $output_file"
else
  echo "转换失败"
fi

