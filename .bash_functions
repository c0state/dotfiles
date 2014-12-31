function bash_colors {
	for i in {0..255} ; do printf "\x1b[38;5;${i}mcolour${i}\n" ; done
}

function build_python_2.7.1 {
	./configure --prefix=/home/stephen/Dropbox/Apps/Linux/Python-2.7.1/$MACHTYPE --with-pydebug --enable-shared && make && make install && echo "Return code was $?"
}

function build_python_3.2 {
	./configure --prefix=/home/stephen/Dropbox/Apps/Linux/Python-3.2/$MACHTYPE --with-pydebug --enable-shared && make && make install && echo "Return code was $?"
}

function build_qpy_script_2.7 {
	echo "Python 2.6 is hardcoded in the PyQ source files; change this if you're using another version!!!" && sleep 10
	env PYTHONHOME=~/Dropbox/Apps/Linux/Python-2.7.1/$MACHTYPE LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/Dropbox/Apps/Linux/Python-2.7.1/$MACHTYPE/lib QHOME=~/Dropbox/Apps/Linux/q ~/Dropbox/Apps/Linux/Python-2.7.1/$MACHTYPE/bin/python setup.py install
}

function build_qpy_script_3.2 {
	echo "Python 2.6 is hardcoded in the PyQ source files; change this if you're using another version!!!" && \
	echo "Also, the following 3 files needed changes:" && \
	echo "_k.c (PyObject redefined)" && \
	echo 'setup.py (sys.maxint --> sys.maxsize, ".so" --> ".cpython-32dm.so")' && \
	echo 'q.py ("lambda(a)" --> "lambda a")' && \
	sleep 10
	env PYTHONHOME=~/Dropbox/Apps/Linux/Python-3.2/$MACHTYPE LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/Dropbox/Apps/Linux/Python-3.2/$MACHTYPE/lib QHOME=~/Dropbox/Apps/Linux/q-python-3.2 ~/Dropbox/Apps/Linux/Python-3.2/$MACHTYPE/bin/python3 setup.py install
	(cd ~/Dropbox/Apps/Linux/q-python-3.2/l32 && ln -f -s p.cpython-32dm.so p.so)
	(cd ~/Dropbox/Apps/Linux/q-python-3.2/l32 && ln -f -s py.cpython-32dm.so py.so)
	(cd ~/Dropbox/Apps/Linux/Python-3.2/i686-pc-linux-gnu/lib/python3.2/site-packages && ln -f -s _k.cpython-32dm.so _k.so)
}

function build_nsenter {
	./configure --prefix=/home/stephen/bin && make nsenter && make install
}

function dlrepo { curl http://android.git.kernel.org/repo > ./repo ; }
function firefox { /home/stephen/Dropbox/Apps/Linux/firefox/firefox ; }
function findnewest {
    if [[ $1 != "" ]]; then
      num_items_to_show="-n $1"
    fi
    find . -type f -printf '%T+ %p\n' | sort -r | head $num_items_to_show ;
}
function fixinsecurecompaudit {
	compaudit | xargs chgrp Users
	compaudit | xargs chmod g-w
	rm -f ~/.zcompdump*
	compinit
}
function logcat { adb logcat -d -v time ; }
function nookicsflash {
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell mount -o rw -t vfat /dev/block/mmcblk0p1 /boot && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell mount -o rw -t ext2 /dev/block/mmcblk0p5 /system && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell mount -o rw -t ext3 /dev/block/mmcblk0p6 /data && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell rm -rf /system/* && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell rm -rf /cache/* && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell rm -rf /data/dalvik-cache/* && \
	(cd $OUT && ~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb sync system) && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell chmod 4755 /system/xbin/su && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell chmod -R a+x /system/bin && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb shell chmod -R a+x /system/xbin && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb push $OUT/kernel /boot/uImage && \
	(cd $OUT && ./ramdisk_tools.sh) && \
	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb push $OUT/ramdisk-internal.img /boot/uRamdisk
	echo flash gapps and reboot
#	~/Dropbox/Apps/Linux/android-sdk-linux_x86/platform-tools/adb reboot && \
#	echo Nook flash successful
}
function nookzipsync {
	repo sync -j4 && \
	(cd build && \
	git fetch http://review.cyanogenmod.com/p/CyanogenMod/android_build refs/changes/61/11161/1 && git cherry-pick FETCH_HEAD && \
	git fetch http://review.cyanogenmod.com/p/CyanogenMod/android_build refs/changes/62/11162/1 && git cherry-pick FETCH_HEAD && \
 	git fetch http://review.cyanogenmod.com/p/CyanogenMod/android_build refs/changes/63/11163/1 && git cherry-pick FETCH_HEAD)
}
function portupdate {
	if [[ $PLATFORM == 'Darwin' ]]; then
		sudo port selfupdate
		sudo port upgrade outdated
	fi
}
function q {
	if [[ $PLATFORM == 'Linux' ]]; then
		env QHOME=~/Dropbox/Apps/Linux/q ~/Dropbox/Apps/Linux/q/l32/q ;
	elif [[ $PLATFORM == 'Darwin' ]]; then
		env QHOME=~/Dropbox/Apps/OSX/q ~/Dropbox/Apps/OSX/q/m32/q ;
	fi
}
function qpython { env QHOME=/home/stephen/Dropbox/Apps/Linux/q rlwrap /home/stephen/Dropbox/Apps/Linux/q/l32/q python.q ; }
function qpython-3.2 { env QHOME=/home/stephen/Dropbox/Apps/Linux/q-python-3.2 rlwrap /home/stephen/Dropbox/Apps/Linux/q-python-3.2/l32/q python.q ; }
function qpythonc { env QHOME=/home/stephen/Dropbox/Apps/Linux/q rlwrap /home/stephen/Dropbox/Apps/Linux/q/l32/q python_noexit.q ; }
function qpythonc-3.2 { env QHOME=/home/stephen/Dropbox/Apps/Linux/q-python-3.2 rlwrap /home/stephen/Dropbox/Apps/Linux/q-python-3.2/l32/q python_noexit.q ; }
function runnew { nohup "$*" 1>/dev/null 2>&1 </dev/null ; }
function sshaws-saasbook { ssh ubuntu@ec2-107-21-177-50.compute-1.amazonaws.com ; }
function sshuls { ssh -X booyeah.gotdns.com -p 9503 $* ; }
function sshuls-bayside { ssh -X baysidenyc.gotdns.com -p 9503 $* ; }
function sshulslts { ssh -X booyeah.gotdns.com -p 9504 $* ; }
function studioforkdb { java -jar ~/Dropbox/Apps/Universal/studioforkdb/studio.jar ; }
function synapticenable {
	xinput set-prop $(xinput list | grep -i synaptic | sed -r -e "s/.*?id=//g" | cut -f 1) "Device Enabled" 1
}
function synapticdisable {
	xinput set-prop $(xinput list | grep -i synaptic | sed -r -e "s/.*?id=//g" | cut -f 1) "Device Enabled" 0
}

if [[ $OSTYPE == 'cygwin' ]]; then
    #function vim { vim.exe "$*"; }

    function build_vim_cygwin {
        ./configure --prefix ~/bin/vim73 --enable-perlinterp=yes --enable-pythoninterp=yes --enable-rubyinterp --with-features=huge --enable-multibyte --with-x --with-vim-name=vim && make && make install && echo "Return code was $?"
    }
fi
