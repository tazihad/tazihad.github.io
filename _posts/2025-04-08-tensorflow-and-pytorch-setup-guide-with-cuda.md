---
title: Tensorflow and PyTorch Setup Guide with Jupyter Notebook and CUDA
description: Learn how to set up TensorFlow and PyTorch with Jupyter Notebook and CUDA for GPU-accelerated machine learning and deep learning on your system.
date: 2025-04-08 13:33:00 +0600
categories: [deep-learning]
tags: [deep-learning, machine-learning, pytorch]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: ../assets/images/2025-04-08-tensorflow-and-pytorch-setup-guide-with-cuda/tensorflow-pytorch-jupyter-setup.png
  lqip: data:image/webp;base64,UklGRl4AAABXRUJQVlA4IFIAAADQAwCdASoUAAsAPzmEuVOvKKWisAgB4CcJZgC06Brh1XH01rtaRAAA/s2CZmXU7Rq/LytsmtAAn9f+iXPml+TEg2P1lXrRPcCQyzyZonCNhOAA
  alt: Tensorflow, PyTorch
---

Befor we continue we have to make sure what is the latest python version for [supported Tensorflow](https://www.tensorflow.org/install/pip#software_requirements).

For me it is `Python 3.9–3.12`.

Now we have to install tensorflow and pytorch. We can install all of these using python. It's better we install python environment so that we don't pollute our system.
There are many ways to create python environment. But we are going to use `conda`.

We are going to install miniconda and start from there. Go to miniconda [website and download](https://www.anaconda.com/docs/getting-started/miniconda/install#macos-linux-installation).

Make sure to install miniconda in a location where you have enough storage. Our directory will become big overtime.

```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
```

We have to check inf conda is available in terminal.

```bash
conda --version
```

If it's available create python environment. Since Latest tersorflow supported python version is 3.12 as of now.
We create:
```bash
conda create -n ml-env python=3.12 -y
```
Then activate it:
```bash
conda activate ml-env
```

Check where conda env is located:
```bash
conda env list
```

Now install Jupyter Notebook inside conda environment.
```sh
conda install notebook -c conda-forge -y
```
> conda-forge is community driven channel. notebook just contain basic jupyterlab. install jupyterlab for full package.

To make `conda` available inside jupyter notebook. So, that we can install any dependency inside jupter notebook.
```bash
# Install the IPython kernel package
conda install ipykernel -y

# Register this environment with Jupyter
python -m ipykernel install --user --name ml-env --display-name "Python (ml-env)"
```

If you have NVIDIA gpu. Make sure to install CUDA drivers from NVIDIA website. And check out [PyTorch website](https://pytorch.org/get-started/locally/#start-locally) for different version that is available.

**CPU**
```bash
python3 -m pip install -U 'tensorflow[and-cuda]'
python3 -m pip install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```
> conda support of PyTorch and Tensorflow has beed deprecated. They now push directly through pip.

**NVIDIA GPU**
```bash
python3 -m pip install -U 'tensorflow[and-cuda]'
python3 -m pip install -U tensorrt tensorrt-bindings tensorrt-libs --extra-index-url https://pypi.nvidia.com
python3 -m pip install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu${CUDA_TK_VER//./}
```

Now run jupyter notebook
```bash
jupyter notebook
```
Select the Kernel:

In the Jupyter interface, open a notebook (or create a new one).

From the top menu, go to `Kernel > Change kernel > Select Python (ml-env)` from the list.

Now your notebook will run using the `ml-env` environment and have access to all the packages you've installed there (including PyTorch, TensorFlow, etc.).

Let's test if Cuda working.

Test from terminal
**Tensorflow GPU Test**
```bash
python -c "import tensorflow as tf; device = 'GPU' if tf.config.list_physical_devices('GPU') else 'CPU'; print(f'TensorFlow is running on: {device}')"
```

**PyTorch GPU Test**
```bash
python -c "import torch; device = 'GPU' if torch.cuda.is_available() else 'CPU'; print(f'PyTorch is running on: {device}')"
```

**Test from Jupyter Notebook Cell**
For Tensorflow
```bash
import tensorflow as tf

print("TensorFlow CUDA Available:", tf.test.is_built_with_cuda())
print("GPU Available:", tf.config.list_physical_devices('GPU'))
```

For PyTorch
```bash
import torch

print("PyTorch CUDA Available:", torch.cuda.is_available())
print("Device Name:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "No GPU")
```













