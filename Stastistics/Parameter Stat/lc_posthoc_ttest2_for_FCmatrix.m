function  [h_posthoc_fdr,pvalue_posthoc,tvalue_posthoc]=lc_posthoc_ttest2_for_FCmatrix()
% ��ROI wise��static/dynamic FC ����ͳ�Ʒ���(post-hoc ttest2+���ˮƽ��FDRУ��)
% ע�⣺����ֻ����������������������������Ƚϣ�������֮��û�бȽϡ�
% input��
%   ZFC_*��ROI wise�ľ�̬�Ͷ�̬�������Ӿ���,size=N*N,NΪROI����
%   Mask������Ȥ�������������ֵ����2D,ά��������������ά��һ�£�,ȱʡ������е����ӽ���ͳ��
%   fdr_threshold�� FDRУ����qֵ
% output��
%   H_FDR:����FDRУ����ľ�̬���߶�̬��������ͳ�Ʒ������������
%   P����̬���߶�̬��������ͳ�Ʒ�����pֵ
%   T: ...Tֵ

%% all input
% =========================================================================
% origin matrix
root_dir = 'D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all';
dir_1 = 'D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all';
dir_2 = fullfile(root_dir,['state',num2str(state),'\state',num2str(state),'_BD']);
dir_3 = fullfile(root_dir,['state',num2str(state),'\state',num2str(state),'_MDD']);
dir_hc = fullfile(root_dir,['state',num2str(state),'\state',num2str(state),'_HC']);
suffix = '*.mat';
n_row = 114;
n_col = 114;
dir_of_all_origin_mat = {dir_1, dir_2, dir_3, dir_hc};

% t-test parameters
contrast = [1 1 1 0];  % �����������

% correction
correction_threshold = 0.05;
correction_method = 'fdr';

% mask
mask='path\to\your\ancova\h_ancova_correction_method.mat';  
mask=mask==1;

% save
if_save=1;
save_path=fullfile(path,['state',num2str(state),'\result']);
% =========================================================================

%% load fc and cov
% load fc
fprintf('Loading FC...\n');
n_group = length(dir_of_all_origin_mat);
dependent_cell = {};
for i = 1 : n_group
    fc = load_FCmatrix(dir_of_all_origin_mat{i},suffix,n_row,n_col);
    fc = prepare_data(fc,mask);  % prepare data
    dependent_cell = cat (1, dependent_cell, fc);
end
fprintf('Loaded FC\n');

%% post-hoc ttest2
disp('performing post-hoc ttest2 for all dependent variables...')
[h_posthoc_without_fdr, pvalue_posthoc,tvalue_posthoc]=lc_ttest2(dependent_cell,contrast);

%% ���ˮƽ��fdr correction,��ʱ��FDRУ���Ķ���Ӧ�����������ĳ��������������ĳ�������������
[h_posthoc_fdr] = post_hoc_fdr(pvalue_posthoc,correction_threshold,correction_method);

%% let h_fdr and p_fdr back to 2D matrix
% note. ͳһ��ȡ�����ǣ��������Խ��ߣ�
h_posthoc_fdr=mat1D_to_mat3D(h_posthoc_fdr,mask);
pvalue_posthoc=mat1D_to_mat3D(pvalue_posthoc,mask);
tvalue_posthoc=mat1D_to_mat3D(tvalue_posthoc,mask);

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

function all_subj_fc = load_FCmatrix(path, suffix, n_row, n_col)
% load all matrix in given path
subj = dir(fullfile(path,suffix));
subj = {subj.name}';
subj_path = fullfile(path,subj);

n_subj = length(subj);
all_subj_fc = zeros(n_subj,n_row,n_col);
for i = 1 : n_subj
    all_subj_fc(i,:,:) = importdata(subj_path{i});
end
end

function fc_mat_prepared = prepare_data(fc_mat,mask)
% prepare data

% extract connectvity in ID_Mask. The result is 1D vector for each subject
fc_mat_prepared = fc_mat(:,mask);

% change Inf/NaN to 1/0
fc_mat_prepared(isinf(fc_mat_prepared)) = 1;
fc_mat_prepared(isnan(fc_mat_prepared)) = 0;
end

function [H,P,T]=lc_ttest2(dependent_cell,contrast)
% ���������������������������Ա�
% �����ܹ���4�飬���������ڵ����飬��
% contrast=[1 1 1 0]
n_g = sum(contrast);
patients_groups_ind = find(contrast==1);

% preallocate
fc=(dependent_cell{1});
n_features=size(fc,2);
H=zeros(n_g,n_features);
P=ones(n_g,n_features);
T=zeros(n_g,n_features);
disp('ttest2...')
for i=1:n_g
    ind=patients_groups_ind(i);
    [h,p,~,s] = ttest2(dependent_cell{ind}, dependent_cell{contrast==0});
    t=s.tstat;
    H(i,:)=h;
    P(i,:)=p;
    T(i,:)=t;
end
disp('ttest2 done')
end

function [h_fdr] = post_hoc_fdr(P,correction_threshold, correction_method)
% P��ά��=n_group*n_features
% �����������ĳ������������ֱ����������У������
[n_g,n_f]=size(P);
h_fdr=zeros(n_g,n_f);
for i=1:n_f
    if strcmp(correction_method,'fdr')
        results=multcomp_fdr_bh(P(:,i),'alpha', correction_threshold);
    elseif strcmp(correction_method,'fwd')
        results=multcomp_bonferroni(P(:,i),'alpha', correction_threshold);
    else
        fprintf('Please indicate the correct correction method!\n');
    end
    h_fdr(:,i)=results.corrected_h;
end
end

function mat2D=mat1D_to_mat3D(mat1D,mask)
% ��1D���������ȡmask���ص�2Dԭʼ����
% mat1D ��ά�ȿ�����n_group*n_features
[n_g,n_f]=size(mat1D);
mat2D=zeros(n_g,size(mask,1),size(mask,2));
for i=1:n_g
    mat2D(i,mask)=mat1D(i,:);
end
end