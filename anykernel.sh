# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Quanta by zaclimon
do.devicecheck=1
do.initd=0
do.modules=0
do.cleanup=1
device.name1=flo
device.name2=deb

# Required for possible inline kernel flashing
if [ ! -f /recovery ] ; then
    alias gunzip="/tmp/anykernel/tools/busybox gunzip";
    alias cpio="/tmp/anykernel/tools/busybox cpio";
fi

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk


# Spread them particles!!
ui_print "Quantum particles are spread throughout the device";


## AnyKernel install
dump_boot;


# Ramdisk modifications

# init.flo.rc
# Add init.quanta.rc
insert_line init.flo.rc "init.quanta.rc" after "init.flo.diag.rc" "import init.quanta.rc";

# Disable mpdecision and thermald (Based on Franco's implementation for Flo)
replace_section init.flo.rc "service thermald" "group radio" "service thermald /system/bin/thermald\n    class main\n    group radio system\n    disabled";
replace_section init.flo.rc "service mpdecision" "group root system" "service mpdecision /system/bin/mpdecision --no_sleep --avg_comp\n    class main\n    user root\n    group root system\n    disabled";


# Write to boot as ramdisk modifications are done
write_boot;

