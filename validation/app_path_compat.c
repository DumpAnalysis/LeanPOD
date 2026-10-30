#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
ssize_t readlink(const char *path, char *buf, size_t size) {
    ssize_t (*real_readlink)(const char *, char *, size_t) = dlsym(RTLD_NEXT, "readlink");
    char own[80];
    snprintf(own, sizeof(own), "/proc/%d/exe", getpid());
    if (strcmp(path, own) == 0) path = "/proc/self/exe";
    return real_readlink(path, buf, size);
}
