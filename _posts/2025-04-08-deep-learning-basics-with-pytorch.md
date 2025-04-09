---
title: Deep Learning Basics with Pytorch - Part 1
description: Part 1 of Deep Learning Basics with Pytorch using JupyterLab
date: 2025-04-08 16:33:00 +0600
categories: [deep-learning]
tags: [deep-learning, machine-learning, pytorch]
pin: false # pin post
math: true # math latex syntax
mermaid: false # diagram & visualizations
image:
  path: ../assets/images/2025-04-08-deep-learning-basics-with-pytorch/deep-learning-basics-banner.png
  lqip: data:image/webp;base64,UklGRlgAAABXRUJQVlA4IEwAAABwAwCdASoUAAsAPzmEuVOvKKWisAgB4CcJYgC7ABrVtaXaUAAA/s2DBAG0CXXVg2oNx6O9rSf7FJgw08q9aJ7lmmvJHpO19QNxoAAA
  alt: Deep Learning Basics with Pytorch Part 1 Banner
---

This tutorial series is a hands on beginner guide for pytorch.

Let's get started. This tutorial series will be comfortable to follow on Unix environment. If you are on Windows make sure to use WSL.

# Environment Setup

We are going to need our environment. There are many ways to create environment. But we are going to use **Conda**.

## Install miniconda
Go to the anaconda site and [install miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install#quickstart-install-instructions).

After you setup and activate miniconda. We are going to install all our libraries in this environment. So that our system won't be dirty.

## Activate environment
Conda is a package manager. Our machine learning tools have first class support in conda. Let's create a basic environment using conda

```sh
conda create -n basic-env python=3.13 -y
conda activate basic-env
```

Check where our conda env located.
```sh
conda env list
```

Now install Jupyter Notebook inside conda.
```sh
conda install -c conda-forge notebook -y
```
> conda-forge is community driven channel. notebook just contain basic jupyterlab. install jupyterlab for full package.

If you are on NVIDIA and have CUDA installed.
```bash
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
```

run it.
```sh
jupyter notebook
```
Open Browser and browse:  
http://localhost:8888/tree

select python3 default kernel. Give any name

Install pytorch and other libraries.
```sh
!pip install torch numpy
```

Next import torch
```python
import torch
```
![import torch](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-08-56 basics.png>)

## What is PyTorch and Tensor?
PyTorch is a library for Processing Tensors. A Tensor is a number or a vector or a matrix or a n-dimensional array.


## Tensors
Let's create a basic tensor.
```python
#Number
t1 = torch.tensor(10)
t1
```
![tensor-ex-1](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-35-10 basics.png>)


Let's create different types of tensors
```python
# Vector
t2 = torch.tensor([10, 20, 30, 40])
t2
```
![vector tensor](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-40-50 basics.png>)
another one
```python
# Matrix
t3 = torch.tensor([[50, 60], 
                   [70, 80], 
                   [90, 10]])
t3
```
![matrix tensor](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-38-50 basics.png>)


All of these are 1 dimensional array

Let's see 3 dimensional tensor
```python
# 3-dimensional array
t4 = torch.tensor([
    [[10, 120, 130], 
     [130, 140, 150]], 
    [[150, 160, 170], 
     [170, 180, 190.]]])
t4
```
![3 dimensional tensor](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-44-59 basics.png>)


Now we can actually see the shape of the tensor
```python
print(t3)
t3.shape
```
The output will be `torch.Size([3, 2])`
Try this on your own

We can also do arithmatic operation with these tensors.
```python
y = t1 + t2
y
```
![arithmatic operation](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-49-53 basics.png>)


## Numpy

Numpy is library for mathmatics and scientific computing in python.

Let's see how Numpy array looks like
```python
import numpy as np

x = np.array([[10, 20], [30, 40]])
x
```
![numpy example](<../assets/images/2025-04-08-deep-learning-basics-with-pytorch/Screenshot 2025-04-08 at 19-53-21 basics.png>)

So, In this tutorial we have just touch the water. We will be continuing this tutorial.  












