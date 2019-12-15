#
# Copyright © 201, Kien Nguyen -lienthiminh@gmail.com-
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it

# Init Script
KERNEL_DIR=/home/nk203/Desktop/test/whyred
KERNEL="Image.gz-dtb"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
BUILD_START=$(date +"%s")
ANYKERNEL_DIR=/home/nk203/Desktop/AnyKernel2
EXPORT_DIR=/home/nk203/Desktop/flashablezips

# Make Changes to this before release
ZIP_NAME="NK-BreakDown"

# Color Code Script
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Tweakable Options Below
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="NK203"
export KBUILD_BUILD_HOST="CL"
export CROSS_COMPILE="/home/nk203/Desktop/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export CROSS_COMPILE_ARM32="/home/nk203/Desktop/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"
export KBUILD_COMPILER_STRING=$(/home/nk203/Desktop/linux-x86/clang-r365631c/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')

# Branding

echo ""
echo ""

PS3='Please enter your choice: '
options=("Build NK Kernel" "Test Build Kernel" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Build NK Kernel")
            echo "You chose choice 1: Build NK Kernel"
# Compilation Scripts Are Below
echo -e "${Green}"
echo "-----------------------------------------------"
echo "  Initializing build to compile Ver: $ZIP_NAME    "
echo "-----------------------------------------------"

echo -e "$Yellow***********************************************"
echo "         Creating Output Directory: out      "
echo -e "***********************************************$nocol"

mkdir -p out

echo -e "$Yellow***********************************************"
echo "          Cleaning Up Before Compile          "
echo -e "***********************************************$nocol"

make O=out clean 
make O=out mrproper

echo -e "$Yellow***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"

make O=out ARCH=arm64 whyred_defconfig

echo -e "$Yellow***********************************************"
echo "          Cooking NK-BreakDown        "
echo -e "***********************************************$nocol"

make -j$(nproc --all) O=out ARCH=arm64 \
		      CC="/home/nk203/Desktop/linux-x86/clang-r365631c/bin/clang" \
                      CLANG_TRIPLE="aarch64-linux-gnu-" | tee ~/build.log

# If the above was successful
if [ -a $KERN_IMG ]; then
   BUILD_RESULT_STRING="BUILD SUCCESSFUL"

echo -e "$Purple***********************************************"
echo "       Making Flashable Zip       "
echo -e "***********************************************$nocol"
   # Make the zip file
   echo "MAKING FLASHABLE ZIP"

   cp -vr ${KERN_IMG} ${ANYKERNEL_DIR}/zImage
   cd ${ANYKERNEL_DIR}
   zip -r9 ${ZIP_NAME}.zip * -x README ${ZIP_NAME}.zip

else
   BUILD_RESULT_STRING="BUILD FAILED"
fi

NOW=$(date +"%m-%d")
ZIP_LOCATION=${ANYKERNEL_DIR}/${ZIP_NAME}.zip
ZIP_EXPORT=${EXPORT_DIR}/${NOW}
ZIP_EXPORT_LOCATION=${EXPORT_DIR}/${NOW}/${ZIP_NAME}.zip

rm -rf ${ZIP_EXPORT}
mkdir ${ZIP_EXPORT}
mv ${ZIP_LOCATION} ${ZIP_EXPORT}
cd ${HOME}

# End the script
echo "${BUILD_RESULT_STRING}!"

# BUILD TIME
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
break
            ;;
        "Test Build Kernel")
            echo "You chose choice 2: Test Build Kernel"
# Compilation Scripts Are Below
echo -e "${Green}"
echo "-----------------------------------------------"
echo "  Initializing build to compile Ver: $ZIP_NAME    "
echo "-----------------------------------------------"

echo -e "$Yellow***********************************************"
echo "         Creating Output Directory: out      "
echo -e "***********************************************$nocol"

mkdir -p out

echo -e "$Yellow***********************************************"
echo "          Cleaning Up Before Compile          "
echo -e "***********************************************$nocol"

make O=out clean 
make O=out mrproper

echo -e "$Yellow***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"

make O=out ARCH=arm64 whyred_defconfig

echo -e "$Yellow***********************************************"
echo "          Cooking BlackBox        "
echo -e "***********************************************$nocol"

make -j$(nproc --all) O=out ARCH=arm64 \
		      CC="/home/nk203/Desktop/linux-x86/clang-r365631c/clang" \
                      CLANG_TRIPLE="aarch64-linux-gnu-"

# If the above was successful
if [ -a $KERN_IMG ]; then
   BUILD_RESULT_STRING="BUILD SUCCESSFUL"

else
   BUILD_RESULT_STRING="BUILD FAILED"
fi

# End the script
echo "${BUILD_RESULT_STRING}!"

# BUILD TIME
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

#Kernel Builder Script By NK203 -lienthiminh@gmail.com-
#Vietnam_Vo_Dich