#!/bin/bash

# 指定输入和输出文件
input_file="CV | Oringinal.pages"
output_file="CV | Scott Cheung.pdf"
past_version_folder="past version"

# 检查 Pages 文件是否存在
if [ ! -f "$input_file" ]; then
  echo "输入文件不存在: $input_file"
  exit 1
fi

# 如果存在旧的输出文件，将其重命名并移动到past version文件夹
if [ -f "$output_file" ]; then
  # 创建past version文件夹（如果不存在）
  if [ ! -d "$past_version_folder" ]; then
    mkdir "$past_version_folder"
  fi
  
  # 获取当前日期，格式为 YYYY-MM-DD
  current_date=$(date +"%Y-%m-%d")

  # 重命名旧的PDF文件，并移动到past version文件夹
  mv "$output_file" "$past_version_folder/CV | ${current_date} | Scott Cheung.pdf"
  echo "旧的 PDF 文件已重命名并移动到: $past_version_folder/CV | ${current_date} | Scott Cheung.pdf"
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

