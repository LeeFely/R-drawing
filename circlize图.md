## 前言

和弦图可以用连接线或条带的方式展示不同对象之间的关系

和弦图主要从以下几个层面来展示关系信息：

1. 连接，可以直接显示不同对象之间存在关系
2. 连接的宽度与关系的强度成正比
3. 连接的颜色可以代表关系的另一种映射，如关系的类型
4. 扇形的大小，代表对象的度量

在 `circlize` 中，有一个专门的函数用于绘制和弦图：`chordDiagram()`，并不需要使用 `circos.link` 来一个个绘制。

`chordDiagram()` 函数支持两种格式的输入数据：

- 邻接矩阵：

  行和列分别表示连接的对象，如果对象之间存在关系，则对应行列的值将表示关系的强度，例如

```
> mat <- matrix(1:9, 3)
> rownames(mat) <- letters[1:3]
> colnames(mat) <- LETTERS[1:3]
> mat
  A B C
a 1 4 7
b 2 5 8
c 3 6 9

```

- 邻接列表：

  包含三列数据，前两列的值表示连接的两个对象，第三列值为连接的强度，例如

```
> df <- data.frame(from = letters[1:3], to = LETTERS[1:3], value = 1:3)
> df
  from to value
1    a  A     1
2    b  B     2
3    c  C     3

```

输入格式的不同，也会影响图形参数的输入格式。如果输入是矩阵，则图形参数也是以矩阵的方式传递，如果输入的是数据框，则图形参数直接添加到后续的列中即可

使用矩阵会比较直观，而数据框能更加灵活的控制图像，两种输入格式也可以相互转换

```
library(tibble)
library(tidyr)

> mat_df <- rownames_to_column(as.data.frame(mat), "from") %>%
+   pivot_longer(cols = -from, names_to = "to", values_to = "value")
>
> mat_df
# A tibble: 9 x 3
  from  to    value
  <chr> <chr> <int>
1 a     A         1
2 a     B         4
3 a     C         7
4 b     A         2
5 b     B         5
6 b     C         8
7 c     A         3
8 c     B         6
9 c     C         9

> pivot_wider(mat_df, names_from = to) %>%
+   column_to_rownames("from") %>%
+   as.matrix()
  A B C
a 1 4 7
b 2 5 8
c 3 6 9

```

## 和弦图

### 1. 简单绘制

要绘制和弦图也很简单，我们先构造矩阵类型的数据

```R
mat <- matrix(sample(18, 18), 3, 6) 
rownames(mat) <- paste0("S", 1:3)
colnames(mat) <- paste0("E", 1:6)

> mat
   E1 E2 E3 E4 E5 E6
S1 14  8  9 18  6  5
S2 13  7  2 15 16 12
S3 17  4  3  1 10 11

```

绘制方式很简单

```R
chordDiagram(mat)
# chordDiagram(df)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-2c829dc1783c6b76.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png

绘制数据框类型的数据也是类似的，这里不再展示

扇形的排列顺序是 `union(rownames(mat), colnames(mat))` 或 `union(df[[1]], df[[2]])`，我们可以使用 `order` 参数来指定排列顺序

```R
par(mfrow = c(1, 2))
chordDiagram(mat, order = c("S2", "S1", "S3", "E4", "E1", "E5", "E2", "E6", "E3"))
circos.clear()

chordDiagram(mat, order = c("S2", "E2", "E3", "S1", "E4", "E1", "S3", "E5", "E6"))
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-fd9fb959be9065ea.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 2. 使用 circos.par() 调整

`chordDiagram()` 函数是使用 `circlize` 的基础函数实现的，可以用 `circos.par()` 函数来控制布局

例如，如果想要让行和列的扇形之间间隔更大，可以设置 `gap.after`

```R
circos.par(gap.after = c(rep(5, nrow(mat)-1), 15, rep(5, ncol(mat)-1), 15))
chordDiagram(mat)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-84f1d4f0e8e2ca26.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

也可以使用命名向量的形式，指定每个扇形的间隔

```R
circos.par(gap.after = c(
  "S1" = 5, "S2" = 5, "S3" = 15, 
  "E1" = 5, "E2" = 5, "E3" = 5, 
  "E4" = 5, "E5" = 5, "E6" = 15)
  )

```

有一个专门的参数 `big.gap` 可以用来指定行列扇形之间的间隔

```R
chordDiagram(mat, big.gap = 30)
circos.clear()

```

但是，必须保证行列之间的扇形没有交叠

与正常的圆形图类似，也可以设置扇形的排列方向以及起始位置

```R
par(mfrow = c(1, 2))
circos.par(start.degree = 85, clock.wise = FALSE)
chordDiagram(mat)
circos.clear()

circos.par(start.degree = 85)
chordDiagram(mat, order = c(rev(colnames(mat)), rev(rownames(mat))))
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-cf93c7686e3c1809.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 3. 颜色

#### 3.1 设置扇形颜色

通常扇形分为两个组，其中一个分组为矩阵的行或数据框的第一列，另一个分组为矩阵的列或数据框的第二列。

连接的颜色默认对应于第一个分组的扇形的颜色，所以，改变扇形的颜色也会影响连接的颜色。

扇形的颜色使用 `grid.col` 参数来设置，最好使用命名向量的方式设置颜色映射。如果只给定颜色向量值，则按照扇形的顺序设置颜色

```R
par(mfcol = c(1, 2))
grid.col <- c(
  S1 = "#ff7f00", S2 = "#984ea3", S3 = "#4daf4a",
  E1 = "grey", E2 = "grey", E3 = "grey", 
  E4 = "grey", E5 = "grey", E6 = "grey"
  )
chordDiagram(mat, grid.col = grid.col)
chordDiagram(t(mat), grid.col = grid.col)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-608afe858b29f55b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

#### 3.2 设置连接颜色

`transparency` 可以设置连接颜色的透明度，`0` 表示不透明，`1` 表示完全透明，默认透明度为 `0.5`

```R
chordDiagram(mat, grid.col = grid.col, transparency = 0.3)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-a6d1b2034509e3d1.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

对于邻接矩阵，连接的颜色可以使用颜色矩阵来指定

```R
col_mat <- rand_color(length(mat), transparency = 0.5)

chordDiagram(mat, grid.col = grid.col, col = col_mat)
circos.clear()

```

因为在创建颜色矩阵时，以及指定了透明度，如果再设置 `transparency` 参数的值将会被忽略

对于邻接列表，可以使用一个与数据框长度相同的颜色向量来指定

```
col <- rand_color(nrow(df))
chordDiagram(df, grid.col = grid.col, col = col)

```

如果关系的强度，即矩阵的值是连续型的，可以传递一个自定义的颜色映射函数

```R
col_fun <- colorRamp2(
  range(mat), c("#9970ab", "#5aae61"), 
  transparency = 0.5
  )
chordDiagram(mat, grid.col = grid.col, col = col_fun)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-104bf77deb2708de.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

对于邻接列表也是类似的，可以使用颜色映射函数或第三列的值

```R
chordDiagram(df, grid.col = grid.col, col = col_fun)
# or
chordDiagram(df, grid.col = grid.col, col = col_fun(df[, 3]))

```

对于邻接矩阵，还可以使用 `row.col` 和 `column.col` 为行或列设置对应的颜色，例如

```R
par(mfcol = c(1, 2))
chordDiagram(mat, grid.col = grid.col, row.col = 1:3)
chordDiagram(mat, grid.col = grid.col, column.col = 1:6)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-5be284db85a0c321.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 4. 连接的边框

`link.lwd`、`link.lty` 和 `link.border` 三个参数用于控制边框的宽度、线型和颜色，参数的值可以是标量值或矩阵。例如

```R
chordDiagram(
  mat, grid.col = grid.col, link.lwd = 2, 
  link.lty = 2, link.border = "red"
  )
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-00322586737d7dc7.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

设置为矩阵

```R
lwd_mat <- matrix(1, nrow = nrow(mat), ncol = ncol(mat))
lwd_mat[mat > 12] <- 2
border_mat <- matrix(NA, nrow = nrow(mat), ncol = ncol(mat))
border_mat[mat > 12] <- "red"
chordDiagram(
  mat, grid.col = grid.col, link.lwd = lwd_mat, 
  link.border = border_mat
  )
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-7550d00061894f28.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

矩阵的大小不一定要与输入数据相同，可以是其子集，但需要保证行列名称对应

```R
border_mat2 <- matrix("black", nrow = 1, ncol = ncol(mat))
rownames(border_mat2) <- rownames(mat)[2]
colnames(border_mat2) <- colnames(mat)
chordDiagram(mat, grid.col = grid.col, link.lwd = 2, 
             link.border = border_mat2)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-d6dc68da3ade5bd3.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

还可以将图形参数设置为三列的数据框，前两列用于标识矩阵的行列，第三列为对应的图形参数的值，例如

```R
lty_df <- data.frame(c("S1", "S2", "S3"), c("E5", "E6", "E4"), c(1, 2, 3))
lwd_df <- data.frame(c("S1", "S2", "S3"), c("E5", "E6", "E4"), c(2, 2, 2))
border_df <- data.frame(c("S1", "S2", "S3"), c("E5", "E6", "E4"), c(1, 1, 1))
chordDiagram(
  mat, grid.col = grid.col, link.lty = lty_df, 
  link.lwd = lwd_df, link.border = border_df
  )
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-1d2e2a1082a87206.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

如果输入数据是数据框，只要将图形参数设置为一个向量即可，会更加方便

### 5. 高亮连接

有时候，我们可能需要着重强调一些连接，我们可以为这些连接设置不同的透明度或者只绘制需要强调的连接

例如，我们为其他连接设置更高的透明度，来凸显我们需要展示的连接

```R
chordDiagram(
  mat, grid.col = grid.col, 
  row.col = c("#FF000080", "#00FF0010", "#0000FF10")
  )
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-7fb9486bb2a1579f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

如果是高亮超过阈值的值，且传递的是颜色矩阵，可以将低于阈值的颜色值设置完全透明

```R
col_mat[mat < 12] <- "#00000000"
chordDiagram(mat, grid.col = grid.col, col = col_mat) 
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-f7f5cb0a059eac53.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

或者传递颜色映射函数

```R
col_fun <- function(x) ifelse(x < 12, "#00000000", "#FF000080")
chordDiagram(mat, grid.col = grid.col, col = col_fun)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-8d2bf6d60ce46cbe.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

但是这两种方法都会绘制所有的连接，如果以数据框的形式来指定需要绘制的连接，那未指定的将不会被绘制

```R
col_df <- data.frame(
  c("S1", "S2", "S3"), c("E5", "E6", "E4"), 
  c("#FF000080", "#00FF0080", "#0000FF80")
  )
chordDiagram(mat, grid.col = grid.col, col = col_df)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-d32a1db57aeedf8a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

高亮邻接列表的连接会更简单，只要传递颜色向量即可

```R
df <- rownames_to_column(as.data.frame(mat), "from") %>%
  pivot_longer(cols = -from, names_to = "to", values_to = "value")
  
col <- rand_color(nrow(df))
col[df[[3]] < 10] <- "#00000000"
chordDiagram(df, grid.col = grid.col, col = col)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-2937541721c0cf0f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

有些图像格式不支持透明度，比如 `GIF`，可以使用 `link.visible` 参数来设置连接的显示，可以是逻辑矩阵或逻辑向量

```R
col <- rand_color(nrow(df))
chordDiagram(df, grid.col = grid.col, link.visible = df[[3]] >= 10)
circos.clear()

```

![img](http://upload-images.jianshu.io/upload_images/18546936-d07eda16b79fb5fe.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 6. 连接的顺序

每个扇形中的连接都会自动调整，让图形看起来更好看，但有时根据宽度对连接进行排序也很有用。

可以使用 `link.sort` 和 `link.decreasing` 两个参数来控制连接的顺序

```R
par(mfcol = c(1, 2))
chordDiagram(
  mat, grid.col = grid.col, 
  link.sort = TRUE, link.decreasing = TRUE
  )
title("link.decreasing = TRUE", cex = 0.6)
chordDiagram(
  mat, grid.col = grid.col, 
  link.sort = TRUE, link.decreasing = FALSE
  )
title("link.decreasing = FALSE", cex = 0.6)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-def2288300e8ab50.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 7. 添加连接的顺序

默认情况下，连接的绘制顺序按照其在矩阵或数据框中出现的顺序进行绘制，`link.zindex` 可以控制连接的绘制顺序,通常更宽的连接在前面绘制

```R
par(mfcol = c(1, 2))
chordDiagram(mat, grid.col = grid.col, transparency = 0)
# 根据值的大小设置连接的添加顺序
chordDiagram(mat, grid.col = grid.col, transparency = 0, 
             link.zindex = rank(mat))

```

![img](http://upload-images.jianshu.io/upload_images/18546936-5ae8187f7d0c94a8.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 8. 自连接

`self.link` 用于控制自连接的样式，可选的值为 `1`、`2`

```R
par(mfcol = c(1, 2))
df2 <- data.frame(start = c("a", "b", "c", "a"), end = c("a", "a", "b", "c"))
chordDiagram(df2, grid.col = 1:3, self.link = 1)
title("self.link = 1")
chordDiagram(df2, grid.col = 1:3, self.link = 2)
title("self.link = 2")

```

![img](http://upload-images.jianshu.io/upload_images/18546936-e4cebd603e4da910.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 9. 对称矩阵

如果邻接矩阵是对称的，可以设置 `symmetric = TRUE`，将绘制下三角，不包含对角线

```R
par(mfcol = c(1, 2))
mat3 <- matrix(rnorm(25), 5)
colnames(mat3) <- letters[1:5]
cor_mat <- cor(mat3)
col_fun <- colorRamp2(c(-1, 0, 1), c("green", "white", "red"))
chordDiagram(cor_mat, grid.col = 1:5, symmetric = TRUE, col = col_fun)
title("symmetric = TRUE")
chordDiagram(cor_mat, grid.col = 1:5, col = col_fun)
title("symmetric = FALSE")

```

![img](http://upload-images.jianshu.io/upload_images/18546936-7fa801eab4ad4b49.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 10. 连接方向

`directional` 参数用于设置连接的方向，对于邻接矩阵，`1` 表示行指向列，邻接列表为第一列指向第二列，`-1` 为反向，`2` 为双向。例如

```R
par(mfrow = c(1, 3))
chordDiagram(
  mat, grid.col = grid.col,
  directional = 1)
chordDiagram(
  mat, grid.col = grid.col, 
  directional = 1, diffHeight = mm_h(5))
chordDiagram(
  mat, grid.col = grid.col, 
  directional = -1)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-581adef96543c6fb.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

默认情况下，连接的两端中代表起始方向的那端会更矮，可以使用 `diffHeight` 设置其高度

邻接矩阵的行名和类名是可以重叠的，可以根据其连接方向来进去区分

```R
mat2 <- matrix(sample(100, 35), nrow = 5)
rownames(mat2) <- letters[1:5]
colnames(mat2) <- letters[1:7]
chordDiagram(mat2, grid.col = 1:7, directional = 1, row.col = 1:5)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-07d7cc2905ac3f31.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

可以删除自连接

```R
mat3 <- mat2
for(cn in intersect(rownames(mat3), colnames(mat3))) {
  mat3[cn, cn] = 0
}

```

连接可以在内部添加箭头来标识方向，当 `direction.type` 参数设置为 `arrows` 时，我们可以为箭头设置不同的图形属性。

如果只要为某些连接添加箭头，则需要传递包含三列的数据框，例如

```R
arr.col <- data.frame(
  c("S1", "S2", "S3"), 
  c("E5", "E6", "E4"), 
  c("black", "red", "blue")
  )
chordDiagram(
  mat, grid.col = grid.col, 
  directional = 1, direction.type = "arrows",
  link.arr.col = arr.col, link.arr.length = 0.2
  )

```

![img](http://upload-images.jianshu.io/upload_images/18546936-cd23effe6efe7be4.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

结合 `arrows` 和 `diffHeight`

```R
arr.col <- data.frame(
  c("S1", "S2", "S3"), 
  c("E5", "E6", "E4"), 
  c("black", "red", "blue")
  )
chordDiagram(
  mat, grid.col = grid.col, directional = 1, 
  direction.type = c("diffHeight", "arrows"),
  link.arr.col = arr.col, link.arr.length = 0.2
  )

```

![img](http://upload-images.jianshu.io/upload_images/18546936-5510405ade7d3a4d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

使用 `link.arr.type` 可以设置箭头的类型，如 `circle`、`ellipse`、`curved` 等。对于连接较多的情况，可以设置为 `big.arrow` 让连接条带显示箭头

```R
chordDiagram(
  matrix(rnorm(64), 8), directional = 1, 
  direction.type = c("diffHeight", "arrows"),
  link.arr.type = "big.arrow"
  )

```

![img](http://upload-images.jianshu.io/upload_images/18546936-84c394767e1d01b2.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

如果 `diffHeight` 设置为负值，则连接的起始端会比终止端更长

```R
chordDiagram(
  matrix(rnorm(64), 8), directional = 1, 
  direction.type = c("diffHeight", "arrows"),
  link.arr.type = "big.arrow",
  diffHeight = -mm_h(2)
  )

```

![img](http://upload-images.jianshu.io/upload_images/18546936-77fee3b60924bb5b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

在前面的图形中，当 `diffHeight` 为正值时，较短的连接端会出现一个条形，表示的是高度的比例。如果要将其删除，可以设置 `link.target.prop = FALSE`，`target.prop.height` 参数可以设置条形的高度

```R
par(mfrow = c(1, 2))
chordDiagram(
  mat, grid.col = grid.col, 
  directional = 1,  
  link.target.prop = FALSE
  )
chordDiagram(
  mat, grid.col = grid.col, 
  directional = 1, diffHeight = mm_h(10), 
  target.prop.height = mm_h(8)
  )

```

![img](http://upload-images.jianshu.io/upload_images/18546936-72f7288b3e0cc944.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 11. 缩放

默认情况下，扇形的范围是根据值来划分的，通过设置 `scale = TRUE`，可以让每个扇形宽度相同，且连接的宽度将表示占比

```R
mat <- matrix(sample(18, 18), 3, 6) 
rownames(mat) <- paste0("S", 1:3)
colnames(mat) <- paste0("E", 1:6)

grid.col <- c(
  S1 = "red", S2 = "green", S3 = "blue",
  E1 = "grey", E2 = "grey", E3 = "grey", 
  E4 = "grey", E5 = "grey", E6 = "grey"
  )
par(mfrow = c(1, 2))
chordDiagram(mat, grid.col = grid.col)
title("Default")
chordDiagram(mat, grid.col = grid.col, scale = TRUE)
title("scale = TRUE")

```

![img](http://upload-images.jianshu.io/upload_images/18546936-72f65639c3b631c4.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### 12. 删减

如果矩阵中存在某些极小的值时，会将其删除，不会显示在图中。例如

```R
mat <- matrix(rnorm(36), 6, 6)
rownames(mat) <- paste0("R", 1:6)
colnames(mat) <- paste0("C", 1:6)
mat[2, ] <- 1e-10
mat[, 3] <- 1e-10

chordDiagram(mat)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-d61afeec543aaa35.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

图中，第二行和第三列没有显示

```R
> circos.info()
All your sectors:
 [1] "R1" "R3" "R4" "R5" "R6" "C1" "C2" "C4" "C5" "C6"

All your tracks:
[1] 1 2

Your current sector.index is C6
Your current track.index is 2

```

从图像信息也可以看出

可以设置 `reduce` 参数的值，如果某一扇形区域占整个圆的比例少于该值，将会删除该区域。

如果将对应行列的值设置为 `0`，也可以删除对应的扇形

```R
mat[2, ] = 0
mat[, 3] = 0

```

### 13. 数据框输入

在前面的例子中，我们着重介绍的是矩阵形式的输入格式，而对于数据框形式的输入，其设置方式也是类似的。

对于数据框形式的输入，其每一行代表的是以连接，许多图形参数都可以以列的方式添加到数据框的后面。

例如下面这些图形属性名称

```R
transparency
col # 也可以是函数
link.border
link.lwd
link.lty
link.arr.length
link.arr.width
link.arr.type
link.arr.lwd
link.arr.lty
link.arr.col
link.visible
link.zindex

```

下面主要介绍其不一样的地方

#### 13.1 两个扇形之间的多个连接

对于矩阵来说，两个扇形之间只能有一个连接，而数据框可以任意多个连接，例如

```
df <- expand.grid(letters[1:3], LETTERS[1:4])
df1 <- df
df1$value <- sample(10, nrow(df), replace = TRUE)
df2 <- df
df2$value <- -sample(10, nrow(df), replace = TRUE)
df <- rbind(df1, df2)

grid.col <- structure(1:7, names = c(letters[1:3], LETTERS[1:4]))
chordDiagram(
  df, grid.col = grid.col, 
  col = ifelse(df$value > 0, "#fb8072", "#80b1d3")
)

```

![img](http://upload-images.jianshu.io/upload_images/18546936-5887e5ff0706d134.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

每对扇形之间都有两个连接，一个为正值，一个为负值。可以将它们分开绘制

```R
par(mfrow = c(1, 2))
chordDiagram(
  df, col = "#fb8072", grid.col = grid.col, 
  link.visible = df$value > 0)
title("Positive links")
chordDiagram(
  df, col = "#80b1d3", grid.col = grid.col, 
  link.visible = df$value < 0)
title("Negative links")

```

![img](http://upload-images.jianshu.io/upload_images/18546936-ba3838d0fe89a763.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

#### 13.2 设置两端的宽度

在前面的所有图形中，连接两端的宽度是一样的，相当于等量信息量在两边进行传递。数据框格式支持两列数据，可以表示两端的宽度

```R
par(mfrow = c(1, 2))

df <- expand.grid(letters[1:3], LETTERS[1:4])
df$value <- 1
# 列名无关紧要
df$value2 <- 3
chordDiagram(df[, 1:3], grid.col = grid.col)
title("one column of values")
# 有两列数据列
chordDiagram(df[, 1:4], grid.col = grid.col) 
title("two columns of values")

```

![img](http://upload-images.jianshu.io/upload_images/18546936-4a8ec25534883356.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

