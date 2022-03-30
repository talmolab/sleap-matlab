function net = loadModel(modelPath)
    if ~endsWith(modelPath, '.h5')
        modelPath = fullfile(modelPath, 'best_model.h5');
    end
    lgraph = importKerasLayers(modelPath,'ImportWeights',true);
    outLayer = regressionLayer('Name','output');
    lgraph = replaceLayer(lgraph, lgraph.Layers(end).Name, outLayer);
    net = assembleNetwork(lgraph);
end