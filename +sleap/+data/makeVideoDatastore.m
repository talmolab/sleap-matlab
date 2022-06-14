function vds = makeVideoDatastore(videoPath)
%makeVideoDatastore Utility function to make a FileDatastore that incrementally reads from video files.
% Copyright 2022 The MathWorks, Inc.
%
vds = fileDatastore(videoPath, "ReadMode", "partialfile", "ReadFcn", @incrementalVideoReadFcn);
end

function [data, reader, done] = incrementalVideoReadFcn(filename, reader)
if isempty(reader)
   reader = VideoReader(filename);
end

data = reader.readFrame(); 
% data = preprocessIm(data, userdata.ResizeScale);
done = ~reader.hasFrame();
end

% function data = preprocessIm(data, inputScale)
% data = rgb2gray(data);
% data = single(data) / 255;
% data = imresize(data, inputScale);
% end