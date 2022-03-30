function jobConfig = loadJobConfig(modelPath)
    jobConfig = jsondecode(fileread(fullfile(modelPath, 'training_config.json')));
end