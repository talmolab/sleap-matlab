function [point, val] = imargmax(I, coordinates)
%IMARGMAX Returns the coordinates of the global peak in an image.
% Usage:
%   [point, val] = imargmax(I)
%   [point, val] = imargmax(I, 'ij')
% 
% Args:
%   I: Image of size [height, width]
%   coordinates: Coordinate system ('xy' (default) or 'ij')
%
% Returns:
%   point: Coordinates as a [1, 2] matrix with [x, y] or [i, j] depending
%   on the input coordinate system.
%   val: Image value at the global maximum.

if nargin < 2 || isempty(coordinates); coordinates = 'xy'; end

[val, ind] = max(I(:));
[i,j] = ind2sub(size(I),ind);

if strcmpi(coordinates,'xy')
    point = [j i];
elseif strcmpi(coordinates,'ij')
    point = [i j];
else
    error('Coordinates must be ''xy'' or ''ij''.')
end

end
