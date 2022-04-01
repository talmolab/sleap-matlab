# SLEAP-MATLAB for Multi-animal Pose Tracking
A MATLAB community toolbox for applying the SLEAP animal pose estimation deep learning framework [\[1\]](#references)

🚧 SLEAP-MATLAB is **early stage**. Interested to use or help create future versions? See [contact info](#contact) below.  
👀 See SLEAP-MATLAB in action with this live script [**demo**](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F85a3255c-4ff5-42ef-9c10-b441318b4322%2F501c4bc8-2509-40fc-aba0-323d33dff728%2Ffiles%2FEphysDemo.mlx&embed=web)

## About SLEAP
[SLEAP](https://sleap.ai) is an open source deep-learning based framework for multi-animal pose tracking. It can be used to track any type or number of animals. 

<p align="center"><img src="https://user-images.githubusercontent.com/3187454/106523005-5f7f1200-6495-11eb-87a5-2b93e251e22a.png" width="512"></p>
<p align="center"><sup>Example of animal pose estimates overlaid on user data video frame</sup></p>

Key SLEAP features include: 
* Single- and multi-animal pose estimation with _top-down_ and _bottom-up_ training strategies
* State-of-the-art pretrained and customizable neural network architectures that deliver accurate predictions with very few labels

## About SLEAP-MATLAB
Currently SLEAP-MATLAB supports inference based on _top-down_ models trained in SLEAP.

SLEAP-MATLAB provides functions for the following key steps:
* **Import** of top-down model components from SLEAP into MATLAB (using the [Deep Learning Toolbox Converter for Tensorflow Models](https://www.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models)) 
* **Composition** of a single composite top-down model as a [`DagNetwork` object](https://www.mathworks.com/help/deeplearning/ref/dagnetwork.html)
* **Visualization** of animal pose estimates for user data within the MATLAB graphics system

The key step of **Prediction** of animal pose estimates, per frame of user data, is handled natively by the [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html) using the function [`predict`](https://www.mathworks.com/help/deeplearning/ref/seriesnetwork.predict.html).

[Pretrained models](/pretrained_models) and [sample data](/sample_data) are included to help get started. 

## Using SLEAP-MATLAB
Usage of SLEAP-MATLAB is subject to its [license terms](LICENSE.md). 

#### Requirements
* [MATLAB](https://www.mathworks.com/solutions/deep-learning.html)
* [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html)
* [Deep Learning Toolbox Converter for Tensorflow Models](https://www.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models)

#### Installation
Installation via the [Add-on Explorer](https://www.mathworks.com/products/matlab/add-on-explorer.html) is recommended. This will install the latest version from GitHub, adding the SLEAP root folder to your [MATLAB path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html). 

#### Getting Started
See the [**demo**](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F85a3255c-4ff5-42ef-9c10-b441318b4322%2F501c4bc8-2509-40fc-aba0-323d33dff728%2Ffiles%2FEphysDemo.mlx&embed=web) illustrating the usage of SLEAP-MATLAB with the included [pretrained models](/pretrained_models) and [sample data](/sample_data).

## Contact
Please direct inquiries and interest(❕) to [talmop@salk.edu](mailto:talmop@salk.edu?subject=\[SLEAP-MATLAB\]) with "SLEAP-MATLAB" included in the subject line. 

## References
\[1\] Pereira, T. _et. al._. Nature Neuroscience 2022.
