# Jetpack 6.1 L4T 36.4

- Author: Otis B.C. Chung



This repository provides tools to build and flash the kernel image, out-of-tree modules, and DTBs to the Jetson Orin Nano Developer Kit.

It also applies the official patches.



## Get Started

### Download All Files

```bash
./download_all.sh
```



### Setup the Build Environment

```bash
./setup_build_env.sh
```



### Compile All

```bash
./compile_kernel.sh
```



### Flash to Jetson Orin Nano Dev. Kit

Before you flash, you have to disable the USB auto-suspend of your host OS. Edit `/etc/default/grub` and add `usbcore.autosuspend=-1` to `GRUB_CMDLINE_LINUX_DEFAULT`. Update your `grub` by `update-grub` and then reboot your computer.

Reference: 

- https://forums.developer.nvidia.com/t/error-might-be-timeout-in-usb-write/284646
- https://unix.stackexchange.com/questions/91027/how-to-disable-usb-autosuspend-on-kernel-3-7-10-or-above

Then you can start flashing your Jetson board.

```bash
./flash_jetson_orin_nano_nvme.sh
```



## Official Patches

We include some official patches in this repository.



### ExFAT Filesystem Issue

Ensure that you have completed [setting up the build environment](#Setup-the-Build-Environment), then run the following command:

```bash
./add_exfat.sh
```

Finally, [compile everything](#Compile-All) and then [flash](#Flash-to-Jetson-Orin-Nano-Dev.-Kit) it to your device.



## Enable Wireguard and IPTables

Ensure that you have completed [setting up the build environment](#Setup-the-Build-Environment), then run the following command:

```bash
./enable_all_kernel_module.sh
```

This configuration includes the [exFAT](#ExFAT-Filesystem-Issue).

Finally, [compile everything](#Compile-All) and then [flash](#Flash-to-Jetson-Orin-Nano-Dev.-Kit) it to your device.



### GPIO Issue

Ensure that you have completed [setting up the build environment](#Setup-the-Build-Environment), then run the following command:

```bash
./modify_pinctrl.sh
./apply_dtsi_changes.sh
```

Finally, [compile everything](#Compile-All) and then [flash](#Flash-to-Jetson-Orin-Nano-Dev.-Kit) it to your device.



### Rev.1 Update: MAXN Power Mode

```bash
sudo rm /etc/nvpmodel.conf
sudo ln -s /etc/nvpmodel/nvpmodel_p3767_0001.conf /etc/nvpmodel.conf
```

[Reference Page](https://developer.nvidia.com/embedded/learn/get-started-jetson-orin-nano-devkit#maxn)



## Configure Your Own Kernel Modules

You can configure your custom kernel modules using `make menuconfig` (also known as `nconfig`).

```bash
cd Linux_for_Tegra/source/kernel/kernel-jammy-src
make ARCH=arm64 O=$(pwd) nconfig
```

After completing the configuration, press **F6** to save your configuration file. Then, replace the contents of the saved file with `Linux_for_Tegra/source/kernel/kernel-jammy-src/arch/arm64/configs/defconfig`.

