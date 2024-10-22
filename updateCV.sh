#!/bin/bash


cd '/Users/xianzhezhang/Desktop/Personal/Job Finding/src/CV'
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
 
fi

# # 使用 AppleScript 将 pages 文件转为 pdf
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



# 使用 Preview 打开并调出打印对话框
osascript <<EOF
on run
    tell application "System Events"
        -- 启用完整键盘访问 (Control + F7)
        key code 97 using control down
        delay 0.5 -- 确保功能启用
    end tell
    
    tell application "Preview"
        open (POSIX file "$PWD/$output_file")
        delay 1 -- 等待 Preview 完全打开文件
        
        -- 将 Preview 应用置于前台
        activate
        delay 0.5 -- 确保应用激活并准备接收输入
        
        tell application "System Events"
            -- 打开打印对话框 (Command + P)
            keystroke "p" using command down
            delay 1 -- 等待打印对话框弹出
            
            -- 按 2 次 Shift + Tab 键
            repeat 2 times
                key code 48 using shift down -- Shift + Tab
                delay 0.2 -- 每次按键后的短暂延迟
            end repeat
            
            -- 空格键 1 次
            keystroke space
            delay 0.5 -- 等待对话框响应
            
            -- 按 Enter 确认保存 PDF
            keystroke return
            delay 0.5
            
            -- 按 Tab 1 次
            keystroke tab
            delay 0.5
            
            -- 空格键 1 次 (触发 PDF 保存)
            keystroke space
            delay 1 -- 等待保存 PDF 完成
            -- 关闭打开的 PDF 文件
            close front document
        end tell
        
   
        
    end tell
    
    tell application "System Events"
        -- 关闭完整键盘访问 (Control + F7)
        key code 97 using control down
    end tell
end run
EOF


# # 重命名文件，假设文件已经成功保存为 CV | Oringinal.pdf
# mv "CV | Oringinal.pdf" "CV | Scott Cheung.pdf"



# 检查输出文件是否成功生成
if [ -f "$output_file" ]; then
  git add .
  git commit -m "Update CV | Scott Update | $(date) | $(hostname)"
  git push
  echo
  echo "旧的 PDF 文件已重命名并移动到: $past_version_folder"
  echo "转换成功，已更新到服务器! ===> $output_file"
else
  echo "转换失败"
fi

cd '/Users/xianzhezhang/Desktop/Personal/Job Finding/src'