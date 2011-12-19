menuentry "Boot Live ISO" {
set isofile="/boot/iso/pinguybeta.iso"
loopback loop (hd0,2)$isofile
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile nomodeset noprompt noeject
initrd (loop)/casper/initrd.lz
}