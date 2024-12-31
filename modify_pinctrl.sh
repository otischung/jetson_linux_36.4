#!/bin/bash

set -euo pipefail

cp src/pinctrl-tegra.c Linux_for_Tegra/source/kernel/kernel-jammy-src/drivers/pinctrl/tegra/pinctrl-tegra.c
cp src/pinctrl-tegra.h Linux_for_Tegra/source/kernel/kernel-jammy-src/drivers/pinctrl/tegra/pinctrl-tegra.h
