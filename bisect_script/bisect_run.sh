#!/usr/bin/env bash

HEIGHT=25
WIDTH=60
CHOICE_HEIGHT=9
BACKTITLE="BISECT AV1 Unit Tests"
TITLE="BISECT AV1 Unit Tests"
MENU="Choose one of the following Unit Tests:"

OPTIONS=(1 "BISECT UBSAN: x86-linux-gcc, integer"
         2 "BISECT UBSAN: x86-linux-gcc, undefined"
         3 "BISECT UBSAN: x86_64-linux-gcc, integer"
	 4 "BISECT UBSAN: x86_64-linux-gcc, undefined"
	 5 "BISECT VALGRND: x86-linux-gcc"
	 6 "BISECT VALGRIND: x86_64-linux-gcc"
	 7 "BISECT ASAN: x86_32-linux-clang"
         8 "BISECT ASAN: x86_64-linux-clang")

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
        1)  ./biubsan_int.sh;;
        2)  ./biubsan_un.sh;;
        3)  ./biubsan_int64.sh;;
        4)  ./biubsan_un64.sh;;
        5)  ./bivalgrind_32.sh;;
        6)  ./bivalgrind_64.sh;;
        7)  ./biasan_32_clang.sh;;
        8)  ./biasan_64_clang.sh;;

esac
