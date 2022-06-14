function net = loadNet(modelPath)
%loadNet Load model network file (HDF5 file format)
%
% Copyright 2022 The MathWorks, Inc.

    if ~endsWith(modelPath, '.h5')
        modelPath = fullfile(modelPath, 'best_model.h5');
    end
    lgraph = importKerasLayers(modelPath,'ImportWeights',true);
    outLayer = regressionLayer('Name','output');
    lgraph = replaceLayer(lgraph, lgraph.Layers(end).Name, outLayer);
    net = assembleNetwork(lgraph);
end