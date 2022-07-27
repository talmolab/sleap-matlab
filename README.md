# SLEAP Toolbox
[![View SLEAP Toolbox on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/114700-sleap-toolbox)

A MATLAB&reg; community toolbox for applying the [SLEAP](https://sleap.ai) multi-animal pose estimation deep learning framework [\[1\]](#references). This toolbox is intended to make it easy to use SLEAP models natively in MATLAB.

🚧 SLEAP Toolbox is **early stage**. Interested in using it or helping to create future versions? See [contact info](#contact) below.

👀 See SLEAP Toolbox in action with this live script [**demo**](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fdefcaf03-d1cf-4f7d-b5f6-490eec8eadb6%2F5b6fcf73-43cf-48d6-8332-786066ed877a%2Ffiles%2Fdemo.mlx&embed=web).

## About SLEAP
[SLEAP](https://sleap.ai) is an open source deep-learning based framework for multi-animal pose tracking. It can be used to track any type or number of animals by training neural networks from user-labeled frames.

<p align="center"><img src="https://user-images.githubusercontent.com/3187454/106523005-5f7f1200-6495-11eb-87a5-2b93e251e22a.png" width="512"></p>
<p align="center"><sup>Visualization of animal pose estimates with <a href= https://sleap.ai>SLEAP</a>-based models overlaid on a user data video frame</sup></p>

## About SLEAP Toolbox
Currently, SLEAP Toolbox supports inference based on _top-down_ models trained in SLEAP. To use it, you must first train a set of models from the SLEAP GUI ([see tutorial](https://sleap.ai/tutorials/tutorial.html)).

SLEAP Toolbox supports the following key steps:
* **Import** of top-down model components from SLEAP into MATLAB 
* **Composition** of a single composite top-down model as a [`DagNetwork`](https://www.mathworks.com/help/deeplearning/ref/dagnetwork.html) object
* **Prediction** of animal pose estimates per frame of user data 
* **Visualization** of animal pose estimates for user data within the MATLAB graphics system

The prediction step is carried out simply, via the function [`predict`](https://www.mathworks.com/help/deeplearning/ref/seriesnetwork.predict.html) in the [Deep Learning Toolbox&trade;](https://www.mathworks.com/products/deep-learning.html).

[Pretrained models](/pretrained_models) and [sample data](/sample_data) are included to help get started. 

## Using SLEAP Toolbox
Usage of SLEAP Toolbox is subject to its [license terms](LICENSE.md). 

#### Requirements
* [MATLAB](https://www.mathworks.com/solutions/deep-learning.html)
* [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html)
* [Deep Learning Toolbox Converter for Tensorflow Models](https://www.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models)

#### Installation
Installation via the [Add-on Explorer](https://www.mathworks.com/products/matlab/add-on-explorer.html) is recommended. This will install the latest version from GitHub, adding the SLEAP Toolbox root folder to your [MATLAB path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).

**Note:** It is NOT necessary to have SLEAP installed in order to run this toolbox. You can train SLEAP on another machine, and then use this toolbox to predict on new data within MATLAB.

#### Getting Started
See the [**demo**](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fdefcaf03-d1cf-4f7d-b5f6-490eec8eadb6%2F5b6fcf73-43cf-48d6-8332-786066ed877a%2Ffiles%2Fdemo.mlx&embed=web) and [sample data](/sample_data).

## Contact
For support for this toolbox, please open a [GitHub issue](https://github.com/talmolab/sleap-matlab/issues) in this repository.

For general SLEAP support, check out the [Official Documentation](https://sleap.ai) or the [support forums on GitHub](https://github.com/talmolab/sleap/issues/new/choose).

Please direct other inquiries and interest(❕) to `talmo@salk.edu` with "SLEAP Toolbox" included in the subject line.

## References
\[1\] T.D. Pereira, N. Tabris, A. Matsliah, D. M. Turner, J. Li, S. Ravindranath, E. S. Papadoyannis, E. Normand, D. S. Deutsch, Z. Y. Wang, G. C. McKenzie-Smith, C. C. Mitelut, M. D. Castro, J. D’Uva, M. Kislin, D. H. Sanes, S. D. Kocher, S. S-H, A. L. Falkner, J. W. Shaevitz, and M. Murthy. [SLEAP: A deep learning system for multi-animal pose tracking](https://www.nature.com/articles/s41592-022-01426-1). *Nature Methods*, pp.1-10, 2022

### Copyright and License Information
Copyright (c) 2019 - 2022 As Indicated Per File.  
Distributed under [license](LICENSE.md) permitting academic and research use.  
For commercial inquiries on using SLEAP for commercial applications, please see the [relevant section in the main SLEAP repository](https://github.com/talmolab/sleap#license). 
