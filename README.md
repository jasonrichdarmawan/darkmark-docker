1. Install X11 Server i.e. for macOS, install XQuartz
2. Try to open xeyes.

```
$ docker build -t xeyes -f Dockerfile.xeyes .
$ docker run --rm xeyes
```