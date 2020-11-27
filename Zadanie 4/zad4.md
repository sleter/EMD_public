Wczytanie danych
================

    library(fpc)
    library(dplyr)
    library(aricode)
    library(factoextra)
    library(ggplot2)
    library(cowplot)

    set.seed(23)
    face <- rFace(1000, p=2, dMoNo=3)

    df = data.frame(x=face[,1], y=face[,2])
    labels = as.integer(attr(face,"grouping"))

    data_plot <- ggplot(df,aes(x,y)) +
      geom_point(col="blue") +
      theme_bw()

    df_temp <- df %>% cbind(labels)
    gold_standard <- ggplot(df_temp,aes(x,y)) +
      geom_point(col=labels) +
      theme_bw()

    plot_grid(data_plot, gold_standard, labels=c("P1", "P2"), ncol=2, nrow=1)

![](zad4_files/figure-markdown_strict/loading_data-1.png)

Trening różnych algorytmów grupowania
=====================================

### `k` wybrane metodą *gap statistic* VS `K` wybrane na podstawie etykiet

    # Według metody *gap statistic* najlepsze K = 4
    fviz_nbclust(df, kmeans, nstart = 25,  method = "gap_stat", nboot = 50)

    ## Clustering k = 1,2,..., K.max (= 10): .. done
    ## Bootstrapping, b = 1,2,..., B (= 50)  [one "." per sample]:
    ## .................................................. 50

![](zad4_files/figure-markdown_strict/algo_tests-1.png)

    # Wybieramy jednak K zgodne z unikalną liczbą etykiet
    K = length(unique(labels)) # 6

### Algorytm k-średnich

    model_kmeans <- eclust(df, "kmeans", k = K, nstart = 25, graph = F)
    model_kmeans

    ## K-means clustering with 6 clusters of sizes 93, 359, 4, 230, 114, 200
    ## 
    ## Cluster means:
    ##             x          y
    ## 1 -0.24144366  0.7890811
    ## 2  0.13195497  3.2360747
    ## 3  0.00000000 28.5000000
    ## 4  0.08744587  7.3775333
    ## 5 -1.73002423 16.7279404
    ## 6  1.99777035 16.9699236
    ## 
    ## Clustering vector:
    ##    [1] 1 2 1 1 2 1 4 4 2 4 2 1 1 1 2 2 1 1 4 1 1 1 2 2 1 2 1 4 4 2 1 1 1 1 1 2 1
    ##   [38] 4 4 2 2 4 1 1 2 2 2 1 1 2 1 2 1 2 4 4 1 4 1 4 1 1 1 1 2 1 4 4 1 4 1 2 4 1
    ##   [75] 4 2 2 2 1 4 2 4 4 2 2 4 2 4 4 1 4 2 1 1 1 1 1 1 1 2 4 1 1 2 4 2 2 2 4 1 2
    ##  [112] 1 1 1 1 1 2 1 2 1 1 2 1 1 1 1 1 1 4 4 2 1 2 1 4 4 2 2 4 1 2 1 1 1 1 4 2 1
    ##  [149] 1 2 1 1 4 2 4 1 4 2 1 2 1 1 2 1 4 2 1 2 1 1 4 1 1 2 1 4 1 1 1 2 4 4 2 4 2
    ##  [186] 2 1 2 1 1 1 1 4 2 2 4 2 4 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [223] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [260] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [297] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [334] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [371] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [408] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [445] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [482] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 4 5 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
    ##  [519] 4 4 4 4 5 4 4 4 4 4 4 4 4 4 4 4 4 4 5 4 4 4 4 4 4 5 4 4 4 5 4 4 4 4 5 4 4
    ##  [556] 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
    ##  [593] 5 4 4 4 4 4 4 4 4 4 4 4 5 4 4 4 4 4 4 4 4 4 4 4 4 4 5 4 4 4 4 4 4 4 4 4 4
    ##  [630] 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 4 4 4
    ##  [667] 4 4 4 4 5 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 6 4 4 4 4 4 6 6 6 6 6 6
    ##  [704] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [741] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [778] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [815] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [852] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [889] 6 6 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [926] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [963] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 3 3 3
    ## [1000] 3
    ## 
    ## Within cluster sum of squares by cluster:
    ## [1] 106.20932 374.29779  89.50000 762.03654 187.61306  65.52071
    ##  (between_SS / total_SS =  96.2 %)
    ## 
    ## Available components:
    ## 
    ##  [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
    ##  [6] "betweenss"    "size"         "iter"         "ifault"       "silinfo"     
    ## [11] "nbclust"      "data"

### Algorytm k-medoidów

    model_pam <- eclust(df, "pam", k = K, graph = F)
    model_pam

    ## Medoids:
    ##       ID            x         y
    ## [1,]  69 -0.480511756  0.378720
    ## [2,] 205  0.099172898  3.099743
    ## [3,] 505  0.007824188  8.839665
    ## [4,] 545 -0.017189896  6.582294
    ## [5,] 873  1.995332379 16.996319
    ## [6,] 902 -1.930762957 16.951077
    ## Clustering vector:
    ##    [1] 1 2 1 2 2 1 3 3 2 3 4 2 1 1 2 2 1 1 4 1 1 1 2 2 1 2 1 4 4 2 1 1 1 1 1 2 1
    ##   [38] 4 4 2 2 4 1 1 2 2 4 1 1 2 1 2 1 2 4 3 2 4 1 4 1 1 1 1 4 1 4 4 1 3 1 2 4 1
    ##   [75] 4 2 2 2 1 4 2 4 4 2 2 4 2 4 4 1 4 2 1 1 1 1 1 1 1 2 4 1 1 2 3 2 2 2 4 1 2
    ##  [112] 1 1 1 1 1 2 1 2 1 1 2 1 1 1 1 1 1 4 4 2 1 2 1 4 4 2 2 4 1 2 1 1 1 1 3 2 1
    ##  [149] 1 2 1 1 4 2 3 1 4 2 1 2 1 1 2 1 3 2 1 2 1 1 3 1 1 2 1 3 2 1 1 2 4 4 4 4 2
    ##  [186] 2 1 2 1 1 1 1 4 2 2 4 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [223] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [260] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [297] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [334] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [371] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [408] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [445] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    ##  [482] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 4 3 4 3 4 3 3 3 4 4 4 3 3 4 3 4 4
    ##  [519] 4 3 4 3 5 4 3 4 4 4 4 3 3 3 4 4 4 3 6 3 4 4 4 4 4 5 4 3 4 3 4 3 3 4 6 4 4
    ##  [556] 3 4 4 3 4 4 4 4 3 4 4 4 4 4 4 3 4 4 4 4 3 4 4 4 3 3 4 3 4 4 4 4 4 3 3 4 3
    ##  [593] 6 4 4 4 4 3 4 4 4 3 4 4 6 3 4 4 4 4 4 4 4 3 3 3 4 4 5 4 4 4 3 4 3 3 3 3 4
    ##  [630] 4 3 4 4 4 4 3 4 4 4 4 3 4 3 4 4 6 4 4 3 4 4 4 4 3 4 3 4 4 4 3 3 5 5 4 4 3
    ##  [667] 4 3 4 4 5 3 4 3 4 3 3 4 4 3 3 4 3 4 3 4 3 4 3 3 3 5 3 4 3 4 4 5 5 5 5 5 5
    ##  [704] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [741] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [778] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [815] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [852] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
    ##  [889] 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [926] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
    ##  [963] 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 5 5
    ## [1000] 5
    ## Objective function:
    ##     build      swap 
    ## 0.8846034 0.8528677 
    ## 
    ## Available components:
    ##  [1] "medoids"    "id.med"     "clustering" "objective"  "isolation" 
    ##  [6] "clusinfo"   "silinfo"    "diss"       "call"       "data"      
    ## [11] "nbclust"

### Algorytm AHC (Agglomerative Hierarchical Clustering)

    model_ahc <- eclust(df, "hclust", k = K, hc_metric = "euclidean", hc_method = "ward.D2", graph = F)
    model_ahc

    ## 
    ## Call:
    ## stats::hclust(d = x, method = hc_method)
    ## 
    ## Cluster method   : ward.D2 
    ## Distance         : euclidean 
    ## Number of objects: 1000

    fviz_dend(model_ahc, show_labels = F, palette = "jco", as.ggplot = T)

![](zad4_files/figure-markdown_strict/algo_tests4-1.png) \#\#\# Algorytm
DBSCAN (Density-Based Spatial Clustering and Application with Noise)

    model_dbscan <- fpc::dbscan(df, eps=0.25, MinPts=4, scale=T)
    model_dbscan

    ## dbscan Pts=1000 MinPts=4 eps=0.25
    ##        0   1   2   3  4   5   6
    ## border 4   0   0   1  1   0   1
    ## seed   0 199 299 187 10 199  99
    ## total  4 199 299 188 11 199 100

Ocena jakości skupień
=====================

### Porównanie z pomocą miary AMI (Adjusted Mutual Information)

    "AMI metric comparison:"

    ## [1] "AMI metric comparison:"

    paste0("   - KMeans - ", AMI(model_kmeans$cluster, labels))

    ## [1] "   - KMeans - 0.793381058555524"

    paste0("   - KMedoids - ", AMI(model_pam$cluster, labels))

    ## [1] "   - KMedoids - 0.744069041000001"

    paste0("   - AHC - ", AMI(model_ahc$cluster, labels))

    ## [1] "   - AHC - 0.786545545246732"

    paste0("   - DBSCAN - ", AMI(model_dbscan$cluster, labels))

    ## [1] "   - DBSCAN - 0.973736002519606"

### Porównanie z pomocą macierzy pomyłek

    rc.names = c(1,2,3,4,5,6)
    # Confusion matrices comaprison:
    #   - KMeans -
    knitr::kable(table(labels, model_kmeans$cluster), row.names=rc.names, col.names=rc.names)

<table>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: right;">1</th>
<th style="text-align: right;">2</th>
<th style="text-align: right;">3</th>
<th style="text-align: right;">4</th>
<th style="text-align: right;">5</th>
<th style="text-align: right;">6</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">1</td>
<td style="text-align: right;">93</td>
<td style="text-align: right;">60</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">46</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">2</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">100</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">3</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">299</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">4</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">184</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">199</td>
</tr>
<tr class="even">
<td style="text-align: left;">6</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
</tbody>
</table>

    #    - KMedoids -
    knitr::kable(table(labels, model_pam$cluster), row.names=rc.names, col.names=rc.names)

<table>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: right;">1</th>
<th style="text-align: right;">2</th>
<th style="text-align: right;">3</th>
<th style="text-align: right;">4</th>
<th style="text-align: right;">5</th>
<th style="text-align: right;">6</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">1</td>
<td style="text-align: right;">88</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">38</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">2</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">100</td>
</tr>
<tr class="odd">
<td style="text-align: left;">3</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">299</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">4</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">117</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="odd">
<td style="text-align: left;">5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">199</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">6</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">1</td>
</tr>
</tbody>
</table>

    #   - AHC -
    knitr::kable(table(labels, model_ahc$cluster), row.names=rc.names, col.names=rc.names)

<table>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: right;">1</th>
<th style="text-align: right;">2</th>
<th style="text-align: right;">3</th>
<th style="text-align: right;">4</th>
<th style="text-align: right;">5</th>
<th style="text-align: right;">6</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">1</td>
<td style="text-align: right;">84</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">2</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">100</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">3</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">299</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">4</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">188</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">199</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">6</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">4</td>
</tr>
</tbody>
</table>

    #   - DBSCAN -
    knitr::kable(table(labels, model_dbscan$cluster)[, 2:7], row.names=rc.names, col.names=rc.names)

<table>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: right;">1</th>
<th style="text-align: right;">2</th>
<th style="text-align: right;">3</th>
<th style="text-align: right;">4</th>
<th style="text-align: right;">5</th>
<th style="text-align: right;">6</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">1</td>
<td style="text-align: right;">199</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">2</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">100</td>
</tr>
<tr class="odd">
<td style="text-align: left;">3</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">299</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">4</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">188</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">199</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">6</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0</td>
</tr>
</tbody>
</table>

### Porównanie z pomocą wizualizacji

    plot_kmeans <- fviz_cluster(model_kmeans, df, stand=F, ellipse=F, show.clust.cent=F, geom="point", palette="jco", ggtheme= theme_classic()) +
                    labs(title="KMeans")
    plot_pam <- fviz_cluster(model_pam, df, stand=F, ellipse=F, show.clust.cent=F, geom="point", palette="jco", ggtheme= theme_classic()) +
                    labs(title="KMedoids")
    plot_ahc <- fviz_cluster(model_ahc, df, stand=F, ellipse=F, show.clust.cent=F, geom="point", palette="jco", ggtheme= theme_classic()) +
                    labs(title="AHC")
    plot_dbscan <- fviz_cluster(model_dbscan, df, stand=F, ellipse=F, show.clust.cent=F, geom="point", palette="jco", ggtheme= theme_classic()) +
                    labs(title="DBSCAN")
    plot_grid(plot_kmeans, plot_pam, plot_ahc, plot_dbscan, labels=c("P1", "P2", "P3", "P4"), ncol=2, nrow=2)

![](zad4_files/figure-markdown_strict/eval3-1.png)
