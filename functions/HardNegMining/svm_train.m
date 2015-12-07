function model= svm_train(Boxes, Tube)

% modified from R-CNN train
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
% 
% This file is part of the R-CNN code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

parameters = init_parameters();
pos_loss = [];
neg_loss = [];
reg_loss = [];
tot_loss = [];

% ------------------------------------------------------------------------
% Get the average norm of the features
% opts.feat_norm_mean = rcnn_feature_stats(imdb, opts.layer, rcnn_model);
% fprintf('average norm = %.3f\n', opts.feat_norm_mean);
% ------------------------------------------------------------------------

X_pos= get_positive_feat( Boxes, Tube);


%  X_pos{i} = rcnn_scale_features(X_pos{i}, opts.feat_norm_mean);
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
first_time = true;
X_neg=[];
% one pass over the data is enough
num_added = 0;
model.detectors.W = [];
model.detectors.B = [];

for t= Tube(1).start: Tube(1).end

    neg_2_add = sample_negatives(first_time, model, Boxes(t,:), parameters);
    
    % Add sampled negatives to each classes training cache, removing
    % duplicates (???)
    
    X_neg = cat(1, X_neg, neg_2_add);
    num_added = num_added + size(neg_2_add,1);
    
    
    % Update model if
    %  - first time seeing negatives
    %  - more than retrain_limit negatives have been added
    %  - its the final image
    is_last_time = (t == Tube(1).end);
    hit_retrain_limit = (num_added > parameters.retrain_limit);
    if (first_time || hit_retrain_limit || is_last_time) && ...
            ~isempty(X_neg)
        fprintf('>>> Updating detector <<<\n');
        fprintf('Current train set holds %d pos examples and %d neg examples\n', ...
            size(X_pos,1), size(X_neg,1));
        [new_w, new_b] = update_model(X_pos, X_neg, parameters);
        model.detectors.W(:, 1)= new_w;
        model.detectors.B(1)= new_b;
        num_added = 0;
        
        z_pos = X_pos * new_w + new_b;
        z_neg = X_neg * new_w + new_b;
        
        % print loss
        pos_loss(end+1) = parameters.svm_C * parameters.pos_loss_weight * ...
                                    sum(max(0, 1 - z_pos));
        neg_loss(end+1) = parameters.svm_C * sum(max(0, 1 + z_neg));
        reg_loss(end+1) = 0.5 * new_w' * new_w + ...
                                    0.5 * (new_b / parameters.bias_mult)^2;
        tot_loss(end+1) = pos_loss(end) + neg_loss(end) + reg_loss(end);

        for l = 1:length(tot_loss)
          fprintf('    %2d: obj val: %.3f = %.3f (pos) + %.3f (neg) + %.3f (reg)\n', ...
                  l, tot_loss(l), pos_loss(l), neg_loss(l), reg_loss(l));
        end
               
        % evict easy examples
        easy = find(z_neg < parameters.evict_thresh);
        
        %X_neg(easy,:) = []; %???
        keep_items= setdiff(1:size(X_neg,1), easy);
        X_neg= X_neg(keep_items,:);
        
    end
    
    first_time = false;
    

end



end




