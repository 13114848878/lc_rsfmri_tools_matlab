function  lc_ancova_for_dfc(dir_of_temporal_properties, path_of_cov_files, correction_threshold, is_save)
% Perform Posthoc ttest2 + FDR correction for temporal properties of dynamic functional connectivity (mean dwell time, fractional windows and number of transitions).
% input:
% 	dir_of_temporal_properties: directory of temporal properties.
% 	path_of_cov_files: directory of of covariances
% 	correction_threshold: currently, there is only FDR correction (e.g., correction_threshold = 0.05).
% 	is_save: save flag.
% output:f, h and p values.
% NOTE. Make sure the order of the dependent variables matches the order of the covariances
%% Inputs
if nargin < 1
    n_state = 2;
    n_row = 114;
    n_col = 114;
    % make folder to save results
    is_save = 1;
    save_path =  uigetdir(pwd,'select saving folder');
    if ~exist(save_path,'dir')
        mkdir(save_path);
    end
    
    % correction
    correction_threshold = 0.05;
    correction_method = 'fdr';
    
    % covariance
    [file_name, path] = uigetfile({'*.xlsx'; '*.txt'; '*.*'},'select path of cov files',pwd,'MultiSelect', 'off');
    cov = xlsread(fullfile(path, file_name));
    group_label = cov(:,2);
    group_design = zeros(size(cov,1),4);
    for i =  1:4
        group_design(:,i) = ismember(group_label, i);
    end
    
    % dependent variable, Y
    fprintf('Loading temporal properties...\n');
    directory = uigetdir(pwd,'select directory of .mat files');
    suffix = '*.mat';
    subj = dir(fullfile(directory,suffix));
    subj = {subj.name}';
    subj_path = fullfile(directory,subj);
    n_subj = length(subj);
    % mask; H derived from ancova
    load D:\WorkStation_2018\WorkStation_dynamicFC_V3\Data\results_cluster\results_of_individual\dfc_STATS_results_fdr.mat
    mask = triu(H,1) == 1;
    all_subj_fc = zeros(n_subj,sum(mask(:)));
    for i = 1:n_subj
        onemat = importdata(subj_path{i});
        onemat = onemat(mask);
        all_subj_fc(i,:)=onemat;
    end
    fprintf('Loaded temporal properties\n');

    % match Y and X
    ms = regexp( subj, '(?<=\w+)[1-9][0-9]*', 'match' );
    nms = length(ms);
    subjid = zeros(nms,1);
    for i = 1:nms
        tmp = ms{i}{1};
        subjid(i) = str2double(tmp);
    end
   [Lia,Locb] = ismember(subjid, cov(:,1));
   cov_matched = cov(Locb,:);
   group_design_matched = group_design(Locb,:);
   design_matrix = group_design_matched;
end
%% ancova
perms = 0;
test_type = 'ttest';
GLM.perms = perms;
contrast = [-1 0 0 1];
GLM.X = design_matrix;
GLM.y = all_subj_fc;
y_name = 'triu_features';
GLM.contrast = contrast;
GLM.test = test_type;
[test_stat,pvalues]=NBSglm(GLM);
% pall=[p_sz(1:end-1),p_mdd(1:end-1),p_bd(1:end-1),p_szbd(1:end-1),p_szmdd(1:end-1),p_bdmdd(1:end-1)];

%% NBS STATAS
% % NBS to test_stat (or pval)
% tt = test_stat(1,:);
% tp = pvalues(1,:);
% STATS.thresh = min(tt(tp<=0.05));
% STATS.test_stat = test_stat;
% STATS.N = n_row;
% STATS.size='extent';
% STATS.alpha = 0.05;
% [n_cnt,con_mat,pval]=NBSstats(STATS);

%% Multiple comparison correction
if strcmp(correction_method, 'fdr')
    results = multcomp_fdr_bh(pvalues, 'alpha', correction_threshold);
elseif strcmp(correction_method, 'fwe')
    results = multcomp_bonferroni(pvalues, 'alpha', correction_threshold);
else
    fprintf('Please indicate the correct correction method!\n');
end
h_corrected = results.corrected_h;

%% to original space (2d matrix)
Tvalues = zeros(n_row,n_col);
Tvalues(mask) = test_stat;
Tvalues = Tvalues+Tvalues';

Pvalues_posthoc = zeros(n_row,n_col);
Pvalues_posthoc(mask) = pvalues;
Pvalues_posthoc = Pvalues_posthoc+Pvalues_posthoc';

H_posthoc = zeros(n_row,n_col);
H_posthoc(mask) = h_corrected;
H_posthoc = H_posthoc+H_posthoc';

%% save
if is_save
    disp('save results...');
    save (fullfile(save_path,['dfc_posthoc_bdvshc_results_',correction_method,'.mat']),'y_name','Tvalues','Pvalues_posthoc','H_posthoc');
    disp('saved results');
end
fprintf('--------------------------All Done!--------------------------\n');
end