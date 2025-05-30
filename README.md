# xv6

This project extends the xv6 operating system's filesystem by adding support for larger files and symbolic links.

## Large File Support

xv6 limits file size to 268 blocks due to its inode structure, which includes 12 direct blocks and one single indirect block. This project increases the file size limit by introducing a double indirect block, allowing files to grow up to 65,803 blocks.

**Key changes include:**

- Reducing the number of direct blocks (`NDIRECT`) from 12 to 11 to allocate space for the double indirect block.
- Modifying the `bmap()` function and related filesystem code to support double indirect addressing while keeping the inode size constant.
- Updating filesystem constants and recreating the disk image to apply changes.
- Proper handling of block allocation and deallocation, including new double indirect blocks.
- Verifying functionality with the provided `bigfile` program and passing all user tests.

## Symbolic Link Implementation

Symbolic links are added to reference files or directories by path, allowing links to span across directories and disks, unlike hard links.

**Features include:**

- A new syscall `symlink(target, path)` to create symbolic links.
- Introduction of a new inode type `T_SYMLINK` and an `O_NOFOLLOW` flag for the `open()` syscall.
- Modification of `open()` to recursively resolve symbolic links by default, with a recursion depth limit to prevent cycles; `O_NOFOLLOW` disables this behavior.
- Ensuring other syscalls like `link()` and `unlink()` operate on the symbolic link itself, not the target file.

## Important 
The "user" file is uploaded in .zip form, you first have to unzip by downloading and then use all the files given.
