function showPeaks(img, allPeaks)
    imshow(img, 'Border', 'tight');
    hold on;
    for i = 1:size(allPeaks,3)
        plot(allPeaks(:,1,i),allPeaks(:,2,i),'.','MarkerSize',10)
    end
    hold off
end
