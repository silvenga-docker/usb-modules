# usbip

A docker image to build and install the usbip kernel module (and friends). Some standard kernels (looking at you, Azure kernel) do not include USB kernel modules. While, yes, you can install the generic mainline kernel... there's downsides to that...

## Setup

```
docker run -it --rm \
    -v /usr/src:/usr/src:ro \
    -v /lib/modules:/lib/modules:ro \
    --privileged \
    test
```

The following paths must be mounted from the host (to build against the correct symbols).

| Host Path      | Container Path | Access     | Why?                                                                                                                                                                                                                                                                                 |
|----------------|----------------|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/lib/modules` | `/lib/modules` | Read-only  | To build modules, the original kernel build parameters are needed. This includes symbols so that built-module can use kernel functions. In the future (hopefully) this will also allow the container to noop if the module is already loaded, or was included with the distribution. |
| `/usr/src`     | `/usr/src`     | Read-only  | The modules directory actually symlinks to `/usr/src`.                                                                                                                                                                                                                               |
| <anywhere>     | `/build`       | Read/Write | To allow the usage of read-only containers the well-known `/build` directory is used. Consider this cache space, the contents are ignored after restarts.                                                                                                                            |

Note that `--privileged` must be set to allow the container to install the kernel module.

## Theory

The idea behind this docker image is to provide K8s environments the ability to access USB devices exposed using `usbipd` to a cluster. My theoretical plan is to:

- On container image start, build the module based on the mounted kernel source.
- `modprobe` the built module.
- On capturing a term signal, unload the module.

Might also be a good idea to allow kernel modules to be mounted, so the container could load existing modules if included.
