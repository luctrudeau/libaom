#!/usr/bin/env bash

HEIGHT=25
WIDTH=60
CHOICE_HEIGHT=9
BACKTITLE="AV1 Unit Tests"
TITLE="AV1 Unit Tests"
MENU="Choose one of the following Unit Tests:"

OPTIONS=(1 "UBSAN: x86-linux-gcc, integer"
         2 "UBSAN: x86-linux-gcc, undefined"
         3 "UBSAN: x86_64-linux-gcc, integer"
	 4 "UBSAN: x86_64-linux-gcc, undefined"
	 5 "VALGRND: x86-linux-gcc"
	 6 "VALGRIND: x86_64-linux-gcc"
	 7 "ASAN: x86-linux-clang"
	 8 "ASAN: x86_64-linux-clang"
	 9 "TSAN")

CHOICE=$(dialog --begin 2 8 \
                --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)  ./ubsan_x86_integer.sh;;
        2)  ./ubsan_x86_undefined.sh;;
        3)  ./ubsan_x86_64_integer.sh;;
        4)  ./ubsan_x86_64_undefined.sh;;
        5)  ./valgrind_x86_linux_gcc.sh;;
        6)  ./valgrind_x86_64_linux_gcc.sh;;
        7)  ./asan_x86_linux_clang.sh;;
        8)  ./asan_x86_64_linux_clang.sh;;
        9)  ./tsan.sh;;

esac
