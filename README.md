# Kernel Module Lab 5 - Two Module Design (Lab 4 v2)

Lab 5: Split kernel module into hello1 (library) and hello2 (client).

## Architecture

- **hello1.ko**: Library module that exports `print_hello()` function
  - Manages linked list of timing records
  - Measures time before and after each print
  - Prints elapsed time on module unload
  
- **hello2.ko**: Client module that uses `print_hello()`
  - Accepts `count` parameter (0-10)
  - Calls `print_hello()` count times
  - Depends on hello1 module

## Compilation

Setup environment variables
```bash
source setup_env.sh
```

Build both modules
```bash
make
```

Check results
```bash
ls -l *.ko
```

## Testing in QEMU

### Prepare QEMU rootfs

Copy modules to busybox install directory

cp hello1.ko hello2.ko ~/repos/busybox/_install/
Recreate rootfs

cd ~/repos/busybox/_install
find . | cpio -H newc -o > ../../rootfs.cpio
cd ../..
gzip -f rootfs.cpio

### Boot QEMU

qemu-system-arm -kernel ~/repos/busybox/_install/boot/zImage
-initrd ~/repos/rootfs.cpio.gz
-machine virt -nographic -m 512
-append "root=/dev/ram0 rw console=ttyAMA0,115200 mem=512M"

## Module Dependencies

hello2 depends on hello1 because:
- hello2 calls `print_hello()` which is exported by hello1
- hello1 must be loaded before hello2
- hello1 can only be unloaded after hello2 is unloaded
