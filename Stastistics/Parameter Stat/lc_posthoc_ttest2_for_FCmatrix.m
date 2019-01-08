function  [h_posthoc_fdr,pvalue_posthoc,tvalue_posthoc]=lc_posthoc_ttest2_for_FCmatrix(mask,fdr_threshold)
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
if nargin<1
    % fc
    path_sz='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\SZ';
    path_bd='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\BD';
    path_mdd='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\MDD';
    path_hc='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\HC';
    suffix='*.mat';
    n_row=4;%�����м���
    n_col=4;%�����м���
    
    % mask
    add_mask=1;
    mask=importdata('D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\results\h_ancova_fdr.mat');
    mask=mask==1;
    
    % correction
    fdr_threshold=0.05;
    correction_method='fdr';
    
    % save
    if_save=1;
    save_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\fullTransitionMatrix1\results';
end

%% load fc and cov
% load fc
fprintf('Loading FC...\n');
fc_sz=load_FCmatrix(path_sz,suffix,n_row,n_col);
fc_bd=load_FCmatrix(path_bd,suffix,n_row,n_col);
fc_mdd=load_FCmatrix(path_mdd,suffix,n_row,n_col);
fc_hc=load_FCmatrix(path_hc,suffix,n_row,n_col);
fprintf('Loaded FC\n');

% ����Э����
% post-hoc ����Ҫ��Э����

%% ׼������
% ��ȡMask�ڵ�����,��ȡ֮�󣬱��Ծ��󽫻���1D����ʽ
if add_mask
    fc_sz=fc_sz(:,mask);
    fc_bd=fc_bd(:,mask);
    fc_mdd=fc_mdd(:,mask);
    fc_hc=fc_hc(:,mask);
end

% Inf/NaN to 1 and 0
fc_sz(isinf(fc_sz))=1;
fc_bd(isinf(fc_bd))=1;
fc_mdd(isinf(fc_mdd))=1;
fc_hc(isinf(fc_hc))=1;

fc_sz(isnan(fc_sz))=0;
fc_bd(isnan(fc_bd))=0;
fc_mdd(isnan(fc_mdd))=0;
fc_hc(isnan(fc_hc))=0;

%% post-hoc ttest2
disp('performing post-hoc ttest2 for all dependent variables...')
DependentFiles={fc_sz,fc_bd,fc_mdd,fc_hc};
contrast=[1 1 1 0];%�����������
[h_posthoc_without_fdr,pvalue_posthoc,tvalue_posthoc]=lc_ttest2(DependentFiles,contrast);

%% ���ˮƽ��fdr correction��
%% ��ʱ��FDRУ���Ķ���Ӧ�����������ĳ��������������ĳ�������������
[h_posthoc_fdr]= post_hoc_fdr(pvalue_posthoc,fdr_threshold,correction_method);

%% let h_fdr and p_fdr back to 2D matrix
% note. ͳһ��ȡ�����ǣ��������Խ��ߣ�
h_posthoc_fdr=mat1D_to_mat3D(h_posthoc_fdr,mask);
pvalue_posthoc=mat1D_to_mat3D(pvalue_posthoc,mask);
tvalue_posthoc=mat1D_to_mat3D(tvalue_posthoc,mask);

% save
if if_save
    disp('save results...');
    save (fullfile(save_path,'h_posthoc_fdr.mat'),'h_posthoc_fdr');
    save (fullfile(save_path,'tvalue_posthoc.mat'),'tvalue_posthoc');
    save (fullfile(save_path,'pvalue_posthoc.mat'),'pvalue_posthoc');
    disp('saved results');
end

fprintf('==================================\n');
fprintf('Completed\n');
end

function all_subj_fc=load_FCmatrix(path,suffix,n_row,n_col)
% ����path�����б��Ե�FC
subj=dir(fullfile(path,suffix));
subj={subj.name}';
subj_path=fullfile(path,subj);

n_subj=length(subj);
all_subj_fc=zeros(n_subj,n_row,n_col);
for i =1:n_subj
    all_subj_fc(i,:,:)=importdata(subj_path{i});
end
end

function [H,P,T]=lc_ttest2(DependentFiles,contrast)
% ���������������������������Ա�
% �����ܹ���4�飬���������ڵ����飬��
% contrast=[1 1 1 0]
n_g=sum(contrast);
patients_groups_ind=find(contrast==1);

% Ԥ����
fc=(DependentFiles{1});
n_features=size(fc,2);
H=zeros(n_g,n_features);
P=ones(n_g,n_features);
T=zeros(n_g,n_features);
disp('ttest2...')
for i=1:n_g
    ind=patients_groups_ind(i);
    [h,p,~,s] = ttest2(DependentFiles{ind}, DependentFiles{contrast==0});
    t=s.tstat;
    H(i,:)=h;
    P(i,:)=p;
    T(i,:)=t;
end
disp('ttest2 done')
end

function [h_fdr]= post_hoc_fdr(P,fdr_threshold,correction_method)
% P��ά��=n_group*n_features
% �����������ĳ������������ֱ����������У������
[n_g,n_f]=size(P);
h_fdr=zeros(n_g,n_f);
for i=1:n_f
    if strcmp(correction_method,'fdr')
        results=multcomp_fdr_bh(P(:,i),'alpha', fdr_threshold);
    else
        results=multcomp_bonferroni(P(:,i),'alpha', fdr_threshold);
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