---
title: Deep Learning Basics with Pytorch - Part 4
description: Part 4 of Deep Learning Basics with Pytorch using JupyterLab
date: 2025-04-20 13:08:00 +0600
categories: [deep-learning, pytorch]
tags: [drafts, deep-learning, machine-learning, pytorch]
pin: false # pin post
math: true # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: ../assets/images/2025-04-20-deep-learning-basics-with-pytorch-4/deep-learning-basics-pytorch-4.webp
  lqip: data:image/webp;base64,UklGRlgAAABXRUJQVlA4IEwAAABwAwCdASoUAAsAPzmGuVOvKSWisAgB4CcJYgC7ABrVtaXaUAAA/s223eqEQtu5aLze9cvsz5dljofVatWyga8Fj+WJp0M3kYLZAAAA
  alt: deep learning basics pytorch
---

A **Neural Network (NN)** is a computational model that tries to mimics bionlogical neural networks (like Human Brain). It has interconected nodes called **neurons**, each of these nodes perform simple mathematical operations as a whole we get a operational output. The nodes takes input data and make predictions.

Let’s break it down step by step to understand the fundamentals of Neural Networks.

## 1. Basic Structure of a Neural Network

A neural network typically consists of three types of layers:

**1. Input Layer:**
- This is where the model receives the input data. Each neuron in the input layer represents one feature of the data (for example, pixels in an image, or features in tabular data).

**2. Hidden Layers**
- These are the layers between the input and output. Each hidden layer contains neurons that process the data from the previous layer.

**3. Output Layer:**
- he output layer produces the final prediction of the model.

## 2. How Neural Networks Work

**1. Forward Propagation:**
- When data is passed through the network, each layer computes the output of its neurons and passes it to the next layer.
- Each neuron performs the following operation:

$$
z = \sum_{i=1}^{n} w_i x_i + b
$$

Where:

- $$w_i$$ = weight of input $$x_i$$
- $b$ = bias term
- $$x_i$$​ = input feature
- The result $$z$$ is then passed through an activation function (e.g., ReLU, Sigmoid, Tanh) to introduce non-linearity into the network, which allows it to learn complex patterns.

**2. Activation Function:**  
The activation function decides whether a neuron should be activated (i.e., whether it should "fire"). 

**3. Loss Function:**  
The goal is to minimize the loss, meaning the difference between the predicted values and actual values.

**4. Backward Propagation:**  

Once the model's predictions are compared to the actual values, the backpropagation algorithm computes the gradient of the loss with respect to each weight in the network.

This gradient tells us how to adjust the weights to reduce the error. The [Gradient Descent]({% post_url 2025-04-15-deep-learning-basics-with-pytorch-3 %}#gradient-descent) algorithm is typically used to update the weights by a small step in the direction that reduces the loss.

## 3. Training a Neural Network  

The training process involves:

1. Initializing the weights randomly.
2. Performing forward propagation to calculate predictions.
3. Calculating the loss using the predicted and actual values.
4. Performing backward propagation to compute gradients.
5. Updating the weights using Gradient Descent or other optimizers like Adam.
6. Repeating this process for multiple epochs (iterations) until the loss converges.

## 4. Example Neural Network in PyTorch  
Here’s a simple neural network built with PyTorch:

```python
import torch
import torch.nn as nn
import torch.optim as optim

# Step 1: Define the Neural Network
class SimpleNN(nn.Module):
    def __init__(self):
        super(SimpleNN, self).__init__()
        # Define layers: input layer (3) -> hidden layer (4) -> output layer (1)
        self.layer1 = nn.Linear(3, 4)  # Input layer (3) to hidden layer (4)
        self.layer2 = nn.Linear(4, 1)  # Hidden layer (4) to output layer (1)
        self.relu = nn.ReLU()          # ReLU activation function

    def forward(self, x):
        x = self.relu(self.layer1(x))  # Pass through first layer and ReLU
        x = self.layer2(x)             # Pass through second layer
        return x

# Step 2: Initialize the model, loss function, and optimizer
model = SimpleNN()
criterion = nn.MSELoss()            # Loss function (Mean Squared Error)
optimizer = optim.SGD(model.parameters(), lr=0.01)  # Optimizer (Stochastic Gradient Descent)

# Step 3: Sample Data (3 input features, 1 output)
inputs = torch.tensor([[1.0, 2.0, 3.0], [2.0, 3.0, 4.0], [3.0, 4.0, 5.0]])  # 3 samples, 3 features
targets = torch.tensor([[6.0], [9.0], [12.0]])  # 3 target values

# Step 4: Training Loop (for 100 epochs)
epochs = 100
for epoch in range(epochs):
    # Forward pass: Compute predicted y
    outputs = model(inputs)

    # Compute the loss
    loss = criterion(outputs, targets)

    # Backward pass: Compute gradients
    optimizer.zero_grad()  # Zero previous gradients
    loss.backward()        # Backpropagate the loss

    # Update weights using gradient descent
    optimizer.step()

    # Print loss every 10 epochs
    if (epoch + 1) % 10 == 0:
        print(f"Epoch [{epoch+1}/{epochs}], Loss: {loss.item()}")

# Step 5: Final predictions after training
print(f"Final Model Output: {model(inputs).detach()}")
```

Output:

```
Epoch [10/100], Loss: 0.8691520690917969
Epoch [20/100], Loss: 0.48098862171173096
Epoch [30/100], Loss: 0.3213127553462982
Epoch [40/100], Loss: 0.23787598311901093
Epoch [50/100], Loss: 0.18800848722457886
Epoch [60/100], Loss: 0.15559352934360504
Epoch [70/100], Loss: 0.13345758616924286
Epoch [80/100], Loss: 0.11807630211114883
Epoch [90/100], Loss: 0.10763207823038101
Epoch [100/100], Loss: 0.10120618343353271
Final Model Output: tensor([[ 6.4489],
        [ 9.2806],
        [12.1123]])
```

This tiny neural network is learning:  
> “Given three numbers, output their sum.”

And it does this by:

- Trying different weights/biases
- Measuring how wrong it is (loss)
- Updating its guesses using gradient descent
- Repeating until it gets good!

## 5. Summary

- **Neural Networks** consist of layers of neurons that perform mathematical operations on input data.
- They use **activation functions** to introduce non-linearity and can learn complex patterns.
- **Backpropagation** and **Gradient** Descent are used to optimize the weights by reducing the loss.
- Neural networks are widely used in **deep learning** for tasks such as classification, regression, image recognition, and more.