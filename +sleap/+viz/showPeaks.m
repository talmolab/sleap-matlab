function showPeaks(img, allPeaks)
%showPeaks Show predicted model peaks overlaid atop test image data
%
% Copyright 2022 The MathWorks, Inc.

    imshow(img, 'Border', 'tight');
    hold on;
    for i = 1:size(allPeaks,3)
        plot(allPeaks(:,1,i),allPeaks(:,2,i),'.','MarkerSize',10)
    end
    hold off
end
