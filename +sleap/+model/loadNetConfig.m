function jobConfig = loadNetConfig(modelPath)
%loadNetConfig Load model configuration file (JSON file format)
%
% Copyright 2022 The MathWorks, Inc.

    jobConfig = jsondecode(fileread(fullfile(modelPath, 'training_config.json')));
end