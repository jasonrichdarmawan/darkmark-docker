# What is DarkMark?

> DarkMark is a C++ GUI tool used to annotate images for use in neural networks. It was written specifically to be used with the Darknet neural network framework, and has several features tailored for use with Darknet and YOLO.

Go to the [DarkMark official repository](https://github.com/stephanecharette/DarkMark)

# How to Build DarMark in Docker

## Test using xeyes.

xeyes is a simple X11 application to test if a Docker container can forward GUI to the host machine.

1. Install X11 Server i.e. for macOS, install XQuartz. Start the X11 Server.
2. Allow host names from which X11 server accepts connections. For macOS, run the command below in the terminal `$ xhost +127.0.0.1`
3. Try to open xeyes by running the command below in the terminal:

```
$ docker build -t xeyes -f Dockerfile.xeyes .
$ docker run --rm xeyes
```

## Test using DarkMark

1. Start the X11 Server.
2. `$ xhost +127.0.0.1`
3. Create a folder named `shared` in this repository. Use this folder for storing the neural network file, dataset, weights that will be used by DarkMark.
4. Try to open DarkMark.

```
# Build the Docker image
$ docker build -t darkmark -f Dockerfile.new .
$ docker run -it --rm -v $PWD/shared:/home/nonroot/shared --name darkmark darkmark

# Open the DarkMark
(nonroot) $ DarkMark
```

If you have never use DarkMark before, watch [the tutorial](https://www.youtube.com/watch?v=RcLL8Lea6Ec&t=1s)

# Tested Environment

1. Apple M1, Docker Desktop v4.12.0 (85629)

# Known Issues

1. If the xhost list is not persistent, every time you reboot, you will get this error (see the top of the error message)
```
(nonroot) $ DarkMark
Authorization required, but no authorization protocol specified
```

The solution is to make the xhost list persistent, by running the command below in the terminal.
```
$ sudo bash -c 'echo 127.0.0.1 >> /etc/X0.hosts'
```

2. If you click on the `Load` button, the window will change to a window for annotating images. If you click the exit button (at the top left or right of the window), the window returns to the main menu in the minimized window.

minimized window

![minimized window](./readme_images/minimized_window.png)

The solution is to drag the 3 line strip to the right.

3. You can't train YOLOv4-tiny with this Docker image. Use [Vertex AI](https://cloud.google.com/vertex-ai/pricing#the-americas) or [Vast.ai](https://console.vast.ai/create/).