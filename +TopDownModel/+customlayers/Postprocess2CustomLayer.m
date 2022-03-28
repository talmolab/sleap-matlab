classdef Postprocess2CustomLayer < nnet.layer.Layer
% This is a custom layer to reshape keypoints from topdown model and scale it back to original
% image 
%
% Author: Karthiga Mahalingam
% Revision: Mar, 2022
%
    properties
        % Minimum threshold
        MinThresh = 0.2;

        % Coordinate system
        Coordinates (1,1) string {mustBeMember(Coordinates, ["xy", "ij"])} = "xy";
        
        % Multiplication scale
        MulScale = 1;

        % Division scale
        DivScale = 1;

        % Bounding box size
        BboxSize (1,2) = [1, 1];
    end

    methods
        function layer = Postprocess2CustomLayer(options)
            arguments
                options.Name = ''
                options.MinThresh = 0;
                options.Coordinates (1,1) string {mustBeMember(options.Coordinates, ["xy", "ij"])} = "xy";
                options.MulScale = 1;
                options.DivScale = 1;
                options.BboxSize (1,2) = [1, 1];
                options.NumInputs = 2;
            end
            propCell = namedargs2cell(options);
            for i = 1:2:length(propCell)
                layer.(propCell{i}) = propCell{i+1};
            end
        end

        function Z2 = predict(layer, cropPeaks, centroidPeaks)
            % Forward input data through the layer at prediction time and
            % output the result.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data
            % Outputs:
            %         Z1, ..., Zm - Outputs of layer forward function

            % If necessary, cast to GPU.

            numI = size(cropPeaks,4);
            C = size(cropPeaks,3);

            [val, ind] = max(cropPeaks,[],[1 2],'linear');
            [i,j,~,~] = ind2sub(size(cropPeaks),ind);
            if strcmpi(layer.Coordinates,"xy")
                peaks = permute(squeeze([j,i]), [2 1 3]);
            elseif strcmpi(layer.Coordinates,"ij")
                peaks = permute(squeeze([i,j]), [2 1 3]);
            end
            val = reshape(val, C, 1, numI);
            val = cat(2, val, val);
            peaks(val<layer.MinThresh) = 0;

            Z1 = single(peaks);

            Z1 = Z1 / layer.DivScale;
            Z1 = Z1 * layer.MulScale;

            
            centroidPeaks = permute(centroidPeaks, [2 3 4 1]);
           
            Z2 = Z1 +  centroidPeaks - (layer.BboxSize * 0.5);
            Z2 = permute(Z2, [4 1 2 3]);
        end

        function [Z2, memory] = forward(layer, cropPeaks, centroidPeaks)
            % at training
            % time and output the result and a memory value.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data
            % Outputs:
            %         Z1, ..., Zm - Outputs of layer forward function
            %         memory      - Memory value for custom backward propagation

            % Layer forward function for training goes here.
            numI = size(cropPeaks,4);
            C = size(cropPeaks,3);

            [val, ind] = max(cropPeaks,[],[1 2],'linear');
            [i,j,~,~] = ind2sub(size(cropPeaks),ind);
            if strcmpi(layer.Coordinates,"xy")
                peaks = permute(squeeze([j,i]), [2 1 3]);
            elseif strcmpi(layer.Coordinates,"ij")
                peaks = permute(squeeze([i,j]), [2 1 3]);
            end
            val = reshape(val, C, 1, numI);
            val = cat(2, val, val);
            peaks(val<layer.MinThresh) = 0;

            Z1 = single(peaks);

            Z1 = Z1 / layer.DivScale;
            Z1 = Z1 * layer.MulScale;

            centroidPeaks = permute(centroidPeaks, [2 3 4 1]);
            Z2 = Z1 +  centroidPeaks - (layer.BboxSize * 0.5);
            Z2 = permute(Z2, [4 1 2 3]);
            memory=[];
        end

        function [dLdX1, dLdX2] = ...
                backward(layer, X1, X2, Z1, dLdZ1, memory)
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
            dLdX1=[]; dLdX2=[];
            if ~isempty(memory)
                dLdX1 = layer.MulScale*(dLdZ1 + (X1/Z1));
                dLdX2 = layer.MulScale*(dLdZ1 + (X2/Z1));
            end
        end
    end
end