function  [h_posthoc_fdr,pvalue_posthoc,tvalue_posthoc]=...
            lc_posthoc_ttest2_for_FCmatrix_zhj( )
% ��ROI wise��static/dynamic FC ����ͳ�Ʒ���(post-hoc ttest2+���ˮƽ��FDRУ��)
% input��
%   ZFC_*��ROI wise�ľ�̬�Ͷ�̬�������Ӿ���,size=N*N,NΪROI����
%   Mask������Ȥ�������������ֵ����2D,ά��������������ά��һ�£�,ȱʡ������е����ӽ���ͳ��
%   fdr_threshold�� FDRУ����qֵ
% output��
%   H_FDR:����FDRУ����ľ�̬���߶�̬��������ͳ�Ʒ������������
%   P����̬���߶�̬��������ͳ�Ʒ�����pֵ
%   T: ...Tֵ

%% all input
% origin matrix
n_groups = str2double(input('Input how many groups:','s'));
path_of_all_origin_mat = {};
for i = 1 : n_groups
    [name, directory] = uigetfile(pwd,'select .mat files');
    path = fullfile(directory, name);
    path_of_all_origin_mat = cat(1, path_of_all_origin_mat, path);
end


% mask: significant inmask of ANCONVA
[file_name, path] = uigetfile({'*.mat'; '*.txt'; '*.*'},'select mask file',pwd, ...
                                        'MultiSelect', 'off');
mask = importdata(fullfile(path, file_name));
mask = mask == 1;
if sum(mask(:)) == 0
    fprintf('All mask data are zero!');
    return
end

% t-test parameters

% correction
correction_threshold = 0.05;
correction_method = 'fdr';

% save
if_save = 1;
save_path = uigetdir(pwd,'select saving folder');

%% load fc and cov
% load fc
fprintf('Loading FC...\n');
n_group = length(path_of_all_origin_mat);
dependent_cell = {};
for i = 1 : n_group
    fc = importdata(path_of_all_origin_mat{i});
    fc = fc.aBc;
    fc = fc(:,mask);
    dependent_cell = cat (1, dependent_cell, fc);
end
fprintf('Loaded FC\n');

%% post-hoc ttest2
disp('performing post-hoc ttest2 for all dependent variables...')
[h_posthoc_without_fdr, pvalue_posthoc,tvalue_posthoc] = lc_ttest2_allpair(dependent_cell);

%% ���ˮƽ��fdr correction,��ʱ��FDRУ���Ķ���Ӧ�����������ĳ��������������ĳ�������������
[h_posthoc_fdr] = lc_post_hoc_fdr(pvalue_posthoc,correction_threshold,correction_method);

%% let h_fdr and p_fdr back to 2D matrix
% note. ͳһ��ȡ�����ǣ��������Խ��ߣ�
h_posthoc_fdr = lc_data2orignalspace(h_posthoc_fdr, mask);
pvalue_posthoc = lc_data2orignalspace(pvalue_posthoc, mask);
tvalue_posthoc = lc_data2orignalspace(tvalue_posthoc, mask);

% save
if if_save
    disp('save results...');
    save (fullfile(save_path,['h_posthoc_',correction_method,'.mat']),'h_posthoc_fdr');
    save (fullfile(save_path,['tvalue_posthoc_',correction_method,'.mat']),'tvalue_posthoc');
    save (fullfile(save_path,['pvalue_posthoc_',correction_method,'.mat']),'pvalue_posthoc');
    disp('saved results');
end

fprintf('==================================\n');
fprintf('Completed\n');
end