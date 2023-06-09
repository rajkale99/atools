# layout of [vendor\_]boot.img

[1. boot.img v0-v2](#1-bootimg-v0-v2)

[2. boot.img v3-v4](#2-bootimg-v3-v4)

[3. vendor_boot.img v3-v4](#3-vendor_bootimg-v3-v4)

[4. signature part](#4-signature-part)

 - [4.1 Boot Image Signature](#41-boot-image-signature-vboot-10)

 - [4.2 AVB Footer](#42-avb-footer-vboot-20)

[5. boot in memory](#5-boot-in-memory)

## 1. boot.img v0-v2
### header
Value at 0x28 is one of {0x00,0x01,0x02,0x03,0x04}, this filed should be read first to identify header version.

              item                        size in bytes             position
    +-----------------------------------------------------------+    --> 0
    |<MAGIC HEADER>                  |     8 (value=ANDROID!)   |
    |--------------------------------+--------------------------|    --> 8
    |<kernel length>                 |     4                    |
    |--------------------------------+--------------------------|    --> 12
    |<kernel offset>                 |     4                    |
    |--------------------------------+--------------------------|    --> 16 (0x10)
    |<ramdisk length>                |     4                    |
    |--------------------------------+--------------------------|    --> 20
    |<ramdisk offset>                |     4                    |
    |--------------------------------+--------------------------|    --> 24
    |<second bootloader length>      |     4                    |
    |--------------------------------+--------------------------|    --> 28
    |<second bootloader offset>      |     4                    |
    |--------------------------------+--------------------------|    --> 32 (0x20)
    |<tags offset>                   |     4                    |
    |--------------------------------+--------------------------|    --> 36
    |<page size>                     |     4                    |
    |--------------------------------+--------------------------|    --> 40 (0x28)
    |<header version>                |     4 (value in [0,1,2]) |
    |--------------------------------+--------------------------|    --> 44
    |<os version & os patch level>   |     4                    |
    |--------------------------------+--------------------------|    --> 48 (0x30)
    |<board name>                    |     16                   |
    |--------------------------------+--------------------------|    --> 64 (0x40)
    |<cmdline part 1>                |     512                  |
    |--------------------------------+--------------------------|    --> 576 (0x240)
    |<hash digest>                   |     32                   |
    |--------------------------------+--------------------------|    --> 608 (0x260)
    |<cmdline part 2>                |     1024                 |
    |--------------------------------+--------------------------|    --> 1632 (0x660)
    |<recovery dtbo length>   [v1]   |     4                    |
    |--------------------------------+--------------------------|    --> 1636
    |<recovery dtbo offset>   [v1]   |     8                    |
    |--------------------------------+--------------------------|    --> 1644
    |<header size>            [v1]   |     4 (v1: value=1648)   |
    |                                |       (v2: value=1660)   |
    |--------------------------------+--------------------------|    --> 1648 (0x670)
    |<dtb  length>            [v2]   |     4                    |
    |--------------------------------+--------------------------|    --> 1652
    |<dtb  offset>            [v2]   |     8                    |
    |--------------------------------+--------------------------|    --> 1660 (0x67c)
    |<padding>                       | min(n * page_size        |
    |                                |           - header_size) |
    +--------------------------------+--------------------------+    --> pagesize

### data

    +-----------------------------------------------------------+    --> pagesize
    |<kernel>                        |   kernel length          |
    |--------------------------------+--------------------------|
    |<padding>                       | min(n * page_size - len) |
    +-----------------------------------------------------------+

    +-----------------------------------------------------------+
    |<ramdisk>                       |   ramdisk length         |
    |--------------------------------+--------------------------|
    |<padding>                       | min(n * page_size - len) |
    +-----------------------------------------------------------+

    +-----------------------------------------------------------+
    |<second bootloader>             | second bootloader length |
    |--------------------------------+--------------------------|
    |<padding>                       | min(n * page_size - len) |
    +-----------------------------------------------------------+

    +-----------------------------------------------------------+
    |<recovery dtbo>          [v1]   | recovery dtbo length     |
    |--------------------------------+--------------------------|
    |<padding>                [v1]   | min(n * page_size - len) |
    +-----------------------------------------------------------+

    +-----------------------------------------------------------+
    |<dtb>                    [v2]   | dtb length               |
    |--------------------------------+--------------------------|
    |<padding>                [v2]   | min(n * page_size - len) |
    +-----------------------------------------------------------+    --> end of data part

## 2. boot.img v3-v4

For partitions: `/boot`, `/init_boot` or `/recovery`.

### header

              item                        size in bytes             position
    +-----------------------------------------------------------+    --> 0
    |<MAGIC HEADER>                  |   8 (value=ANDROID!)     |
    |--------------------------------+--------------------------|    --> 8
    |<kernel size>                   |   4                      |
    |--------------------------------+--------------------------|    --> 12
    |<ramdisk size>                  |   4                      |
    |--------------------------------+--------------------------|    --> 16
    |<os version & os patch level>   |   4                      |
    |--------------------------------+--------------------------|    --> 20
    |<header size>                   |   4                      |
    |--------------------------------+--------------------------|    --> 24
    |<reserved>                      |   4 * 4                  |
    |--------------------------------+--------------------------|    --> 40 (0x28)
    |<header version>                |   4 (value in [3|4])     |
    |--------------------------------+--------------------------|    --> 44
    |<cmdline>                       |   1024+512=1536          |
    |--------------------------------+--------------------------|    --> 1580
    |<signature_size>   (v4 only)    |   4 (values in [4096|0]) |
    |--------------------------------+--------------------------|    --> 1584
    |<padding>                       | min(n * page_size        |
    |                                |           - header_size) |
    +--------------------------------+--------------------------+    --> pagesize=4096

### data

    +-----------------------------------------------------------+    --> pagesize
    |<kernel>                        |   kernel length          |
    +-----------------------------------------------------------+    --> + kernel len
    |<ramdisk>                       |   ramdisk length         |
    +-----------------------------------------------------------+    --> + ramdisk len
    |<boot signature>   (v4 only)    |   boot signature length  |
    |                                |   GKI 1.0 : 4K           |
    |                                |   GKI 2.0 : 16K          |
    +--------------------------------+--------------------------+    --> + boot sig len
    |<padding>                       | min(n * page_size - len) |
    +-----------------------------------------------------------+

## 3. vendor\_boot.img v3-v4

For partitions: `/vendor_boot` or `/vendor_kernel_boot`.

### header

              item                        size in bytes             position
    +-----------------------------------------------------------+    --> 0
    |<MAGIC HEADER>                  |     8 (vaue=VNDRBOOT)    |
    |--------------------------------+--------------------------|    --> 8
    |<header version>                |     4 (value=3)          |
    |--------------------------------+--------------------------|    --> 12
    |<page size>                     |     4                    |
    |--------------------------------+--------------------------|    --> 16
    |<kernel load addr>              |     4                    |
    |--------------------------------+--------------------------|    --> 20
    |<ramdisk load addr>             |     4                    |
    |--------------------------------+--------------------------|    --> 24
    |<vendor ramdisk total size>     |     4                    |
    |--------------------------------+--------------------------|    --> 28
    |<vendor cmdline>                |     2048                 |
    |--------------------------------+--------------------------|    --> 2076
    |<tags offset>                   |     4                    |
    |--------------------------------+--------------------------|    --> 2080
    |<board name>                    |     16                   |
    |--------------------------------+--------------------------|    --> 2096
    |<header size>                   |     4 (v3: value=2112)   |
    |                                |     4 (v4: value=2128)   |
    |--------------------------------+--------------------------|    --> 2100
    |<dtb size>                      |     4                    |
    |--------------------------------+--------------------------|    --> 2104
    |<dtb load addr>                 |     8                    |
    |--------------------------------+--------------------------|    --> 2112
    |<vendor ramdisk table size>     |     4   (v4 only)        |
    |--------------------------------+--------------------------|    --> 2116
    |<vendor ramdisk table entry num>|     4   (v4 only)        |
    |--------------------------------+--------------------------|    --> 2120
    |<vendor ramdisk table entry size|     4   (v4 only)        |
    |--------------------------------+--------------------------|    --> 2124
    |<bootconfig size>               |     4   (v4 only)        |
    |--------------------------------+--------------------------|    --> 2128
    |<padding>                       | min(n * page_size        |
    |                                |           - header_size) |
    +--------------------------------+--------------------------+    --> pagesize

### data


    +------------------+-------------+--------------------------+    --> pagesize
    |                  | ramdisk 1   |                          |
    |                  |-------------+                          |
    |                  | ramdisk 2   |                          |
    |<vendor ramdisks> |-------------+   padded len             |
    |                  | ramdisk n   |                          |
    |                  |-------------+                          |    --> pagesize + vendor_ramdisk_total_size
    |                  | padding     |                          |
    +------------------+-------------+--------------------------+    --> pagesize + vendor_ramdisk_total_size + padding
    |                  |   dtb       |                          |
    |<dtb>             |-------------+   padded len             |
    |                  | padding     |                          |
    +------------------+-------------+--------------------------+    --> dtb offset + dtb size + padding
    |<vendor ramdisk > | entry 1     |                          |
    |     table>       |-------------+                          |
    |                  | entry 2     |   padded len             |
    |                  |-------------+                          |
    |                  | entry n     |                          |
    |      (v4)        |-------------+                          |
    |                  | padding     |                          |
    +------------------+----------------------------------------+    --> vrt offset + vrt size + padding
    |<bootconfig>            (v4)    |   padded len             |
    +--------------------------------+--------------------------+



## 4. signature part

### 4.1 Boot Image Signature (VBoot 1.0)

    +--------------------------------+--------------------------+    --> end of data part
    |<signature>                     | signature length         |
    |--------------------------------+--------------------------+
    |<padding>                       | defined by boot_signer   |
    +--------------------------------+--------------------------+

### 4.2 AVB Footer (VBoot 2.0)

                         item                        size in bytes             position
    +------+--------------------------------+-------------------------+ --> end of data part (say locaton +0)
    |      | VBMeta Header                  | total 256               |
    |      |                                |                         |
    |      |   - Header Magic "AVB0"        |     4                   |
    |      |   - avb_version Major          |     4                   |
    |      |   - avb_version Minor          |     4                   |
    |      |   - authentication_blob_size   |     8                   |
    |      |   - auxiliary blob size        |     8                   |
    |      |   - algorithm type             |     4                   |
    |      |   - hash_offset                |     8                   |
    |      |   - hash_size                  |     8                   |
    |      |   - signature_offset           |     8                   |
    |      |   - signature_size             |     8                   |
    |      |   - pub_key_offset             |     8                   |
    |VBMeta|   - pub_key_size               |     8                   |
    | Blob |   - pub_key_metadata_offset    |     8                   |
    |      |   - pub_key_metadata_size      |     8                   |
    |      |   - descriptors_offset         |     8                   |
    |      |   - descriptors_size           |     8                   |
    |      |   - rollback_index             |     8                   |
    |      |   - flags                      |     4                   |
    |      |   - RESERVED                   |     4                   |
    |      |   - release string             |     47                  |
    |      |   - NULL                       |     1                   |
    |      |   - RESERVED                   |     80                  |
    |      |--------------------------------+-------------------------+ --> + 256
    |      | Authentication Blob            |                         |
    |      |   - Hash of Header & Aux Blob  | alg.hash_num_bytes      | --> + 256 + hash_offset
    |      |   - Signature of Hash          | alg.signature_num_bytes | --> + 256 + signature_offset
    |      |   - Padding                    | align by 64             |
    |      +--------------------------------+-------------------------+
    |      | Auxiliary Blob                 |                         |
    |      |   - descriptors                |                         | --> + 256 + authentication_blob_size + descriptors_offset
    |      |   - pub key                    |                         | --> + 256 + authentication_blob_size + pub_key_offset
    |      |   - pub key meta data          |                         | --> + 256 + authentication_blob_size + pub_key_metadata_offset
    |      |   - padding                    | align by 64             |
    |      +--------------------------------+-------------------------+
    |      | Padding                        | align by block_size     |
    +------+--------------------------------+-------------------------+ --> + (block_size * n)

    +---------------------------------------+-------------------------+
    |                                       |                         |
    |                                       |                         |
    | DONOT CARE CHUNK                      |                         |
    |                                       |                         |
    |                                       |                         |
    +---------------------------------------+-------------------------+

    +---------------------------------------+-------------------------+ --> partition_size - block_size
    | Padding                               | block_size - 64         |
    +---------------------------------------+-------------------------+ --> partition_size - 64
    | AVB Footer                            | total 64                |
    |                                       |                         |
    |   - Footer Magic "AVBf"               |     4                   |
    |   - Footer Major Version              |     4                   |
    |   - Footer Minor Version              |     4                   |
    |   - Original image size               |     8                   |
    |   - VBMeta offset                     |     8                   |
    |   - VBMeta size                       |     8                   |
    |   - Padding                           |     28                  |
    +---------------------------------------+-------------------------+ --> partition_size

## 5. boot in memory

```
       ┌────────────────────────────────────────┐
       │           kernel                       │
       ├──────────────────┬─────────────────────┤
       │                  │ vendor ramdisk 1    │
       │                  ├─────────────────────┤
       │                  │ vendor ramdisk 2    │
       │  vendor ramdisks ├─────────────────────┤
       │                  │   ...               │
       │                  ├─────────────────────┤
       │                  │ vendor ramdisk n    │
       ├──────────────────┴─────────────────────┤
       │  generic ramdisk (from init_boot/boot) │
       ├──────────────────┬─────────────────────┤
       │                  │parameters           │
       │                  ├─────────────────────┤
       │                  │param size  (4)      │
       │   bootconfig     ├─────────────────────┤
       │                  │param checksum (4)   │
       │                  ├─────────────────────┤
       │                  │bootconfig magic(12) │ --> "#BOOTCONFIG\n"
       └──────────────────┴─────────────────────┘
```