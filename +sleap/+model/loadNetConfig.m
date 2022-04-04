function jobConfig = loadNetConfig(modelPath)
    jobConfig = jsondecode(fileread(fullfile(modelPath, 'training_config.json')));
end