classdef Postprocess1CustomLayer < nnet.layer.Layer
% This is a custom layer to crop out individual animals based on confidence
% heatmap from centroid model
%
% Author: Karthiga Mahalingam
% Revision: Mar, 2022

    properties
        % Minimum threshold to consider for heatmap
        MinThresh = 0;

        % Standard deviation for Gaussian filtering
        Sigma = 0;

        % Connectivity to identify regional peaks
        Connectivity = 8;

        % Multiplication scale
        MulScale = 1;

        % Division scale
        DivScale = 1;

        % Bounding box size of cropped animals
        BboxSize (1,2) = [1, 1];

        % Input scale
        InputScale (1,1) = 1;

        % Maximum animals to allocate per batch
        MaxAnimals (1,1) = 50;
    end

    methods
        function layer = Postprocess1CustomLayer(options)
            arguments
                options.Name = ''
                options.MinThresh = 0;
                options.Sigma = 0;
                options.Connectivity = 8;
                options.MulScale = 1;
                options.DivScale = 1;
                options.BboxSize = [1, 1];
                options.NumInputs = 2;
                options.InputScale = 1;
                options.NumOutputs = 3;
            end

            propCell = namedargs2cell(options);
            for i = 1:2:length(propCell)
                layer.(propCell{i}) = propCell{i+1};
            end
        end

        function [crops, centroidPeaks, numAnimalsPerImage] = predict(layer, I, inputIm)
            % Forward input data through the layer at prediction time and
            % output the result.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data
            % Outputs:
            %         Z1, ..., Zm - Outputs of layer forward function

            % If necessary, extract from dlarray
            if isa(I, 'dlarray')
                I = extractdata(I);
                inputIm = extractdata(inputIm);
            end

            numIm = size(I,4);
            Z = zeros(1,1,2,layer.MaxAnimals, 'like', inputIm);
            numAnimalsPerImage = zeros(1,1,1,numIm,'like',inputIm);
            animalCnt = 1; % counter for # of animals

            % Identify (x,y)peaks for every image
            for i = 1:numIm
                img = I(:,:,:,i);
                % Layer forward function for prediction goes here.
                if layer.Sigma > 0; img = imgaussfilt(img,layer.Sigma); end

                img(img < layer.MinThresh)=0;

                BW = imregionalmax(img,layer.Connectivity);
                [r,c] = find(BW);
                numAnimalsThisImage = length(c);

                % Make sure to run only until maximum animals specified
                if animalCnt+numAnimalsThisImage > layer.MaxAnimals
                    numAnimalsThisImage = layer.MaxAnimals - animalCnt + 1;
                    numAnimalsPerImage(1,1,1,i) = numAnimalsThisImage;
                    Z(1,1,:,animalCnt:animalCnt+numAnimalsThisImage-1) = [c(1:numAnimalsThisImage) r(1:numAnimalsThisImage)]';
                    animalCnt = animalCnt+numAnimalsThisImage;
                    break;
                end

                numAnimalsPerImage(1,1,1,i) = numAnimalsThisImage;
                Z(1,1,:,animalCnt:animalCnt+numAnimalsThisImage-1) = [c r]';
                animalCnt = animalCnt+numAnimalsThisImage;
            end

            % delete unused preallocated memory
            if animalCnt-1 < layer.MaxAnimals
                Z(:,:,:,animalCnt:end) = [];
            end

            Z1 = Z / layer.DivScale;
            Z1 = Z1 * layer.MulScale;

            inputIm = imresize(inputIm,layer.InputScale);
            
            % extract crops based on peaks
            crops = zeros(layer.BboxSize(1), layer.BboxSize(2), 1, size(Z1, 4), 'like',inputIm);

            n=1;
            for i = 1:size(inputIm,4)
                for j = 1:numAnimalsPerImage(1,1,1,i)
                    x = Z1(1,1,1,n);
                    y = Z1(1,1,2,n);

                    R = imref2d(layer.BboxSize, [x - layer.BboxSize(1)/2, x + layer.BboxSize(1)/2], [y - layer.BboxSize(2)/2, y + layer.BboxSize(2)/2]);
                    crops(:,:,1,n) = imwarp(inputIm(:,:,:,i),affine2d(),'OutputView',R);
                    n=n+1;
                end
            end

            centroidPeaks = single(Z1);

        end

        function [crops, centroidPeaks, numAnimalsPerImage, memory] = forward(layer, I, inputIm)
            % (Optional) Forward input data through the layer at training
            % time and output the result and a memory value.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data
            % Outputs:
            %         Z1, ..., Zm - Outputs of layer forward function
            %         memory      - Memory value for custom backward propagation

            % Layer forward function for training goes here.
            % If necessary, extract from dlarray
            if isa(I, 'dlarray')
                I = extractdata(I);
                inputIm = extractdata(inputIm);
            end

            numIm = size(I,4);
            Z = zeros(1,1,2,layer.MaxAnimals, 'like', inputIm);
            numAnimalsPerImage = zeros(1,1,1,numIm,'like',inputIm);
            animalCnt = 1; % counter for # of animals
            for i = 1:numIm
                img = I(:,:,:,i);
                % Layer forward function for prediction goes here.
                if layer.Sigma > 0; img = imgaussfilt(img,layer.Sigma); end

                img(img < layer.MinThresh)=0;

                BW = imregionalmax(img,layer.Connectivity);
                [r,c] = find(BW);
                numAnimalsThisImage = length(c);

                % Make sure to run only until maximum animals specified
                if animalCnt+numAnimalsThisImage > layer.MaxAnimals
                    numAnimalsThisImage = layer.MaxAnimals - animalCnt + 1;
                    numAnimalsPerImage(1,1,1,i) = numAnimalsThisImage;
                    Z(1,1,:,animalCnt:animalCnt+numAnimalsThisImage-1) = [c(1:numAnimalsThisImage) r(1:numAnimalsThisImage)]';
                    animalCnt = animalCnt+numAnimalsThisImage;
                    break;
                end

                numAnimalsPerImage(1,1,1,i) = numAnimalsThisImage;
                Z(1,1,:,animalCnt:animalCnt+numAnimalsThisImage-1) = [c r]';
                animalCnt = animalCnt+numAnimalsThisImage;
            end

            % delete unused preallocated memory
            if animalCnt-1 < layer.MaxAnimals
                Z(:,:,:,animalCnt:end) = [];
            end

            Z1 = Z / layer.DivScale;
            Z1 = Z1 * layer.MulScale;

            inputIm = imresize(inputIm,layer.InputScale);

            crops = zeros(layer.BboxSize(1), layer.BboxSize(2), 1, size(Z1, 4), 'like',inputIm);

            n=1;
            for i = 1:size(inputIm,4)
                for j = 1:numAnimalsPerImage(1,1,1,i)
                    x = Z1(1,1,1,n);
                    y = Z1(1,1,2,n);

                    R = imref2d(layer.BboxSize, [x - layer.BboxSize(1)/2, x + layer.BboxSize(1)/2], [y - layer.BboxSize(2)/2, y + layer.BboxSize(2)/2]);
                    crops(:,:,1,n) = imwarp(inputIm(:,:,:,i),affine2d(),'OutputView',R);
                    n=n+1;
                end
            end

            centroidPeaks = single(Z1);
            memory=[];
        end

        function [dLdX1, dLdX2] = ...
                backward(layer, X1, X2, Z1, Z2, Z3, dLdZ1, dLdZ2, dLdZ3, memory)
            % (Optional) Backward propagate the derivative of the loss
            % function through the layer.
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X1, ..., Xn       - Input data
            %         Z1, ..., Zm       - Outputs of layer forward function
            %         dLdZ1, ..., dLdZm - Gradients propagated from the next layers
            %         memory            - Memory value from forward function
            % Outputs:
            %         dLdX1, ..., dLdXn - Derivatives of the loss with respect to the
            %                             inputs
            %         dLdW1, ..., dLdWk - Derivatives of the loss with respect to each
            %                             learnable parameter

            % Layer backward function goes here.
            if isa(X1, 'dlarray')
                X1 = extractdata(X1);
                X2 = extractdata(X2);
            end

            dLdX1=single([]); dLdX2=single([]);
            if ~isempty(memory)
                dLdX1 = layer.MulScale*(dLdZ1 + (X1/Z1));
                dLdX2 = layer.MulScale*(dLdZ3 + (X2/Z3))+layer.MulScale*(dLdZ2 + (X1/Z2));
            end
        end

    end
end