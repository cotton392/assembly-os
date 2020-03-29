#!/bin/bash
# <数字>_<ファイルの用途名>ディレクトリ内で実行することを想定
qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c