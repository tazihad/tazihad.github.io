---
title: Deep Learning Basics with Pytorch - Part 3
description: Part 3 of Deep Learning Basics with Pytorch using JupyterLab
date: 2025-04-15 13:33:00 +0600
categories: [deep-learning, pytorch]
tags: [drafts, deep-learning, machine-learning, pytorch]
pin: false # pin post
math: true # math latex syntax
mermaid: false # diagram & visualizations
published: false # publish post
image:
  path: ../assets/images/2025-04-15-deep-learning-basics-with-pytorch-3/deep-learning-basics-pytorch-3.webp
  lqip: data:image/webp;base64,UklGRlgAAABXRUJQVlA4IEwAAABwAwCdASoUAAsAPzmGuVOvKSWisAgB4CcJYgC7ABrVtaXaUAAA/s223eqEQtu5aLze9cvsz5dljofVatWyga8Fj+WJp0M3kYLZAAAA
  alt: deep learning basics pytorch
---

# Gradient Descent
Gradient descent is a fundamental optimization algorithm used in Machine Learning to minimize loss or prediction.
When we determine the prediction we have to predict like if we overshoot the steps it shouldn't be too large or too small.

Gradient descent is used in training many machine learning models, including linear regression, logistic regression, and neural networks.

## Loss
The loss in linear regression is how far our prediction is from the regression line. When we create the linear regression line from the given data. We get a line. When we predict, we determine a prediction. And the loss is the value of the prediction and regression line data.

In the [last tutorial]({% post_url 2025-04-09-deep-learning-basics-with-pytorch-2 %}) we predicted score. Now we can check the loss.

```python
import torch

# Your data
X = torch.tensor([10., 20, 30, 40]).view(-1, 1)
Y_true = torch.tensor([480., 520, 710, 680]).view(-1, 1)

# Model's predictions (example: y = 9x + 350)
Y_pred = torch.tensor([440., 530, 620, 710]).view(-1, 1)

# Calculate MSE loss
loss = torch.mean((Y_true - Y_pred) ** 2)
print(f"Loss: {loss.item():.2f}")  # Output: Loss: 2550.00
```
output: `Loss: 2675.00`

If we show this visually
```python
import matplotlib.pyplot as plt

plt.scatter(X, Y_true, label='Actual Scores')
plt.plot(X, Y_pred, 'r-', label='Predictions')
plt.title(f"Loss = {loss.item():.2f}")
plt.xlabel('Study Hours'), plt.ylabel('Exam Score')
plt.legend()
plt.show()
```

![loss](../assets/images/2025-04-15-deep-learning-basics-with-pytorch-3/loss.webp)

When we give more predictions. We have more losses. And with these data our next guess can be more closer to accurate.


