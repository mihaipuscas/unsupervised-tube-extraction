% ------------------------------------------------------------------------
function param = init_parameters()
% ------------------------------------------------------------------------
param.retrain_limit = 2000;
param.evict_thresh = -1.2;
param.hard_thresh = -1.0001;
% cache.hard_thresh = -0.0001;
param.svm_C= 10^-4;
param.bias_mult= 10;
param.pos_loss_weight= 2;