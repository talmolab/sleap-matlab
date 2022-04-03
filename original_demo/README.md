# Multi-animal Pose Tracking using SLEAP in MATLAB

This repository contains an implementation and examples of how to use deep neural network models for pose estimation trained in [SLEAP](https://sleap.ai) to track multiple body parts of freely moving animals using the [MATLAB Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html).

<img src="https://user-images.githubusercontent.com/3187454/106523005-5f7f1200-6495-11eb-87a5-2b93e251e22a.png" width="512">


## Demo

This demo illustrates how to run inference with a trained top-down multi-instance SLEAP model natively in MATLAB.

To run the demo, run the [`demo.mlx`](https://github.com/murthylab/sleap-matlab/tree/main/original_demo/demo.mlx) from this folder. See [`demo.pdf`](https://github.com/murthylab/sleap-matlab/tree/main/original_demo/demo.pdf) for a saved version of the outputs.

All data and supporting dependencies are included in the folder. This demo was tested on [MATLAB R2020b](https://www.mathworks.com/help/releases/R2020b/index.html) and requires the [Image Processing Toolbox](https://www.mathworks.com/help/releases/R2020b/images/index.html) and [Deep Learning Toolbox](https://www.mathworks.com/help/releases/R2020b/deeplearning/index.html).


## Contributing

Interested in contributing to this repository? Feel free to [submit a pull request](https://github.com/murthylab/sleap-matlab/pulls), but please be sure to include a written acknowledgment of your consent with the [Contributor License Agreement](https://github.com/murthylab/sleap-matlab/blob/main/sleap-cla.pdf).

For legal questions, please direct inquiries to `talmo@salk.edu`.
