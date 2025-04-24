---
title: TLDR Markdown
author: cotes
date: 2019-08-08 14:10:00 +0800
categories: [Blogging, Tutorial]
tags: [writing]
render_with_liquid: false
---

## Write a comment

this is post
> this is comment

## Write a prompt tip

> The posts' _layout_ has been set to `post` by default, so there is no need to add the variable _layout_ in the Front Matter block.
{: .prompt-tip }

## write prompt info

> The benefit of reading the author information from the file `_data/authors.yml`{: .filepath } is that the page will have the meta tag `twitter:creator`, which enriches the [Twitter Cards](https://developer.twitter.com/en/docs/twitter-for-websites/cards/guides/getting-started#card-and-content-attribution) and is good for SEO.
{: .prompt-info }

## write a prompt warning
By default, the image is centered, but you can specify the position by using one of the classes `normal`, `left`, and `right`.

> Once the position is specified, the image caption should not be added.
{: .prompt-warning }

## write a prompt danger

> The Jekyll tag `{% highlight %}` is not compatible with this theme.
{: .prompt-danger }

## Add file name in top

  ```yaml
  cdn: https://cdn.com
  ```
  {: file='_config.yml' .nolineno }

## Disable line number in codes

`.nolineno` removes line number

```yaml
with line number
cdn: cdn.com
python: python.com
```

```yaml
without line number
cdn: cdn.com
python: python.com
```
{: .nolineno }

## Make code little right
- To specify the resource path prefix for the current post/page range, set `media_subpath` in the _front matter_ of the post:

  ```yaml
  ---
  media_subpath: /path/to/media/
  ---
  ```
  {: .nolineno }