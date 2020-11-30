# Graph Regularised Hashing (GRH)

Current version: 1.0. Distributed under a Creative Commons Attribution-NonCommercial License: http://creativecommons.org/licenses/by-nc/4.0/deed.en_US

This code is an implementation of the Graph Regularised Hashing model described in the publication:

[Graph Regularised Hashing. Sean Moran and Victor Lavrenko. European Conference on Information Retrieval, 2015.](http://link.springer.com/chapter/10.1007%2F978-3-319-16354-3_15#page-1)

GRH learns effective hash functions for approximate nearest neighbour search using a modicum of supervision. The model achieves state-of-the-art retrieval effectiveness on standard image datasets.

## Prerequisites:

1. MATLAB
2. libSVM: https://www.csie.ntu.edu.tw/~cjlin/libsvm/
3. liblinear: https://www.csie.ntu.edu.tw/~cjlin/liblinear/
4. BudgetedSVM: http://www.dabi.temple.edu/budgetedsvm/

Compile the three SVM libraries for your machine and place in the grh/libraries directory.

If you use the GRH code for a publication, please consider a citation to the following paper:

```
@incollection{
year={2015},
isbn={978-3-319-16353-6},
booktitle={Advances in Information Retrieval},
volume={9022},
series={Lecture Notes in Computer Science},
editor={Hanbury, Allan and Kazai, Gabriella and Rauber, Andreas and Fuhr, Norbert},
doi={10.1007/978-3-319-16354-3_15},
title={Graph Regularised Hashing},
url={http://dx.doi.org/10.1007/978-3-319-16354-3_15},
publisher={Springer International Publishing},
author={Moran, Sean and Lavrenko, Victor},
pages={135-146},
language={English}
}
```

## Usage

1. Obtain the pre-processed dataset files for MNIST, CIFAR-10 and NUSWIDE here:
https://www.dropbox.com/sh/pvso066sqd2z8ja/AABu7dxMx92lhlLLXLUpg_jMa?dl=0

2. Compile libsvm, liblinear and budgetedsvm for your system and place into grh/libraries folder.

3. Edit the properties in initialise.m to fit your system and requirements (e.g. hashcode length, dataset, amount of supervision, paths to datasets and results directory etc).

4. run_hash.m

## Copyright

Copyright (C) by Sean Moran, University of Edinburgh

Please send any bug reports to sean.j.moran@gmail.com
