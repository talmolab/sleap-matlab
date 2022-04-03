function net = compose(net, topdownNet, inputScale, BboxSize, minThreshold, centroidConfig, topdownConfig)
% This helper function combines centroid and top-down model along with
% custom layers in between to form a single DAG network object
% 
% Author: Karthiga Mahalingam
% Revision: Mar, 2022

arguments
    % centroid model
    net DAGNetwork 

    % top-down model
    topdownNet DAGNetwork
    
    % Input Scale
    inputScale (1,1)

    % Bounding box size
    BboxSize (1,2) 

    % Minimum Threshold
    minThreshold (1,1)

    % Centroid model configuration
    centroidConfig (1,1) struct

    % Topdown model configuration
    topdownConfig (1,1) struct
end

% Since array layer names for both centroid and topdown models have
% commonalities, create unique names for topdown model inorder to combine
% all into a single model
centroidNames = arrayfun(@(x) string(x.Name), net.Layers);
tdNames = arrayfun(@(x) string(x.Name), topdownNet.Layers);
sameNames = tdNames==centroidNames;
newtdNames = tdNames;
newtdNames(sameNames) = matlab.lang.makeUniqueStrings(centroidNames(sameNames), tdNames(sameNames));
larrayTd = topdownNet.Layers;

topDownConn = topdownNet.Connections;
topDownConn.Source = string(topDownConn.Source);
topDownConn.Destination = string(topDownConn.Destination);

topDownConnWOIn = topDownConn;
topDownConnWOIn.Destination(contains(topDownConnWOIn.Destination, "/")) = ...
    extractBefore(topDownConnWOIn.Destination(contains(topDownConnWOIn.Destination, "/")), "/");
topDownConnWOIn.Source(contains(topDownConnWOIn.Source, "/")) = ...
    extractBefore(topDownConnWOIn.Source(contains(topDownConnWOIn.Source, "/")), "/");

for i = 1:length(topdownNet.Layers)
    sourceIdx = find(topDownConnWOIn.Source==larrayTd(i).Name);
    for n = 1:length(sourceIdx)
        topDownConn.Source(sourceIdx(n)) = strrep(topDownConn.Source(sourceIdx(n)), ...
            larrayTd(i).Name, newtdNames(i));
    end

    destIdx = find(topDownConnWOIn.Destination==larrayTd(i).Name);
    for n = 1:length(destIdx)
        topDownConn.Destination(destIdx(n)) = strrep(topDownConn.Destination(destIdx(n)), ...
            larrayTd(i).Name, newtdNames(i));
    end
    
    larrayTd(i).Name = newtdNames(i);
end

% Create layerGrah object 
lgraph = layerGraph(net);

lgraph = removeLayers(lgraph, 'output');

larray = [sleap.model.topdown.customlayers.Postprocess1CustomLayer('Name', 'postprocesscentroidmodel', ...
    'MinThresh', minThreshold, ...
    'MulScale', centroidConfig.model.heads.centroid.output_stride/inputScale, ...
    'BboxSize', BboxSize, 'InputScale', 1/inputScale); ...
    larrayTd(2:end-1); ...
    sleap.model.topdown.customlayers.Postprocess2CustomLayer('Name', 'postprocesstopdownmodel', ...
    'MulScale', topdownConfig.model.heads.centered_instance.output_stride, ...
    'BboxSize', BboxSize)];

lgraph = addLayers(lgraph, larray);

lgraph = connectLayers(lgraph, 'CentroidConfmapsHead_0', 'postprocesscentroidmodel/in1');
lgraph = connectLayers(lgraph, 'input', 'postprocesscentroidmodel/in2');

% Make sure connections for topdown model do not get reordered when
% connecting with centroid model
connT = lgraph.Connections;
for i = 2:height(topDownConn)-1
    if ~isequal(connT(connT.Source==topDownConn.Source(i),:), topDownConn(i,:))
        if nnz(connT.Destination==topDownConn.Destination(i))
            lgraph = disconnectLayers(lgraph, connT.Source{connT.Destination==topDownConn.Destination(i)}, ...
                connT.Destination{connT.Destination==topDownConn.Destination(i)});
        end
        lgraph = connectLayers(lgraph, connT.Source{connT.Source==topDownConn.Source(i)}, ...
            topDownConn.Destination{i});
    end
end

lgraph = connectLayers(lgraph, 'postprocesscentroidmodel/out2', 'postprocesstopdownmodel/in2');

% Connect output layer to form DAG network model
outLayer = regressionLayer('Name','routput');
lgraph = addLayers(lgraph, outLayer);
lgraph = connectLayers(lgraph, 'postprocesstopdownmodel', 'routput');

outLayer2 = regressionLayer('Name','routput2');
lgraph = addLayers(lgraph, outLayer2);
lgraph = connectLayers(lgraph, 'postprocesscentroidmodel/out3', 'routput2');

% create dag network
net = assembleNetwork(lgraph);
end