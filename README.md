# Jetpack 6.1 L4T 36.4

- Author: Otis B.C. Chung
- LinkedIn: https://www.linkedin.com/in/otischung/



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
