function vds = makeVideoDatastore(videoPath)
%makeVideoDatastore   Utility function to make a FileDatastore that incrementally reads from video files.
%
%   Usage:
%
%       >> z = makeVideoDatastore('xylophone.mp4');
%       >> frame1 = z.read();
%       >> frame2 = z.read();
%       >> frame3 = z.read();
%       >> whos
%         Name          Size                Bytes  Class                                Attributes
%
%         frame1      240x320x3            230400  uint8
%         frame2      240x320x3            230400  uint8
%         frame3      240x320x3            230400  uint8
%         z             1x1                     8  matlab.io.datastore.FileDatastore
%

vds = fileDatastore(videoPath, "ReadMode", "partialfile", "ReadFcn", @incrementalVideoReadFcn);
end

function [data, reader, done] = incrementalVideoReadFcn(filename, reader)
if isempty(reader)
    % First read from this filename. Construct the reader object.
    reader = VideoReader(filename);
end

data = reader.readFrame(); %gpuArray(reader.readFrame());
data = preprocessIm(data, 0.5);
done = ~reader.hasFrame();
end

function data = preprocessIm(data, inputScale)
data = rgb2gray(data);
data = single(data) / 255;
data = imresize(data, inputScale);
end

% function data = incrementalVideoReadFcn(filename, offset, size)
%     if isempty(reader)
%         % First read from this filename. Construct the reader object.
%         reader = VideoReader(filename);
%     end
%
%     data =  reader.readFrame();
%     done = ~reader.hasFrame();
% end