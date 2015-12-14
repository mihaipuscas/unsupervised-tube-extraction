% ------------------------------------------------------------------------
function [w, b] = update_model(X_pos, X_neg, parameters)
% ------------------------------------------------------------------------
solver = 'liblinear';
liblinear_type = 3;  % l2 regularized l1 hinge loss
%liblinear_type = 5; % l1 regularized l2 hinge loss

num_pos = size(X_pos, 1);
pos_inds = 1:num_pos;

num_neg = size(X_neg, 1);
neg_inds = 1:num_neg;


switch solver
    case 'liblinear'
        ll_opts = sprintf('-w1 %.5f -c %.5f -s %d -B %.5f', ...
            parameters.pos_loss_weight, parameters.svm_C, ...
            liblinear_type, parameters.bias_mult);
        fprintf('liblinear opts: %s\n', ll_opts);
        X = sparse(size(X_pos,2), num_pos+num_neg);
        X(:,1:num_pos) = X_pos(pos_inds,:)';
        X(:,num_pos+1:end) = X_neg(neg_inds,:)';
        y = cat(1, ones(num_pos,1), -ones(num_neg,1));
%         llm = liblinear_train(y, X, ll_opts, 'col');
        llm = train(y, X, ll_opts, 'col')

        w = single(llm.w(1:end-1)');
        b = single(llm.w(end)*parameters.bias_mult);
        
    otherwise
        error('unknown solver: %s', solver);
end