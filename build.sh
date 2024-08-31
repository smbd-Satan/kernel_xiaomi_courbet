TOOLCHAIN_DIR="$HOME/toolchains/neutron-clang/bin/"
current_dir=$(pwd)
AK_DIR="$current_dir/AnyKernel3"
function checkToolchain {
	if [ -d "$TOOLCHAIN_DIR" ]; then #checking toolchain...
  		echo "The toolchain (NeutronClang) is found in ${TOOLCHAIN_DIR}"
	else
  		echo "NeutronClang is not found in ${TOOLCHAIN_DIR}. Initializing download sequence..."
  		mkdir -p "$HOME/toolchains/neutron-clang"
  		cd "$HOME/toolchains/neutron-clang"
  		curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
  		bash antman -S=09092023
  		cd "$current_dir"
  		echo "current dir is $(pwd)"
	fi	
}
function compile {
	export ARCH=arm64
	export PATH="$HOME/toolchains/neutron-clang/bin:$PATH"
	make O=out courbet_defconfig
	make -j$(nproc --all) O=out CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJDUMP=llvm-objdump STRIP=llvm-strip
}
function checkAK3 {
	if [ -d "$AK_DIR" ]; then #checking AK3...
  		echo "AnyKernel3 directory is okay."
	else
  		echo "AnyKernel3 is not found. Will be downloaded..."
  		git clone https://github.com/smbd-Satan/AnyKernel3.git
	fi
	echo "Toolchain and AnyKernel are set. Starting compilation in "
	for (( i=5; i>=0; i-- )); do
    		echo "$i"
    		sleep 1
	done
}
checkToolchain
checkAK3
compile
