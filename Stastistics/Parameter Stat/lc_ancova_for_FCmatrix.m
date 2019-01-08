function  [fvalue_ancova,pvalue_ancova,h_ancova_fdr]=lc_ancova_for_FCmatrix(mask,fdr_threshold)
% ��ROI wise��static/dynamic FC ����ͳ�Ʒ���(ancova+fdr)
%%input��
%   ZFC_*��ROI wise�ľ�̬�Ͷ�̬�������Ӿ���,size=N*N,NΪROI����
%   ID_Mask������ȤROI��id,ȱʡ������е����ӽ���ͳ��
% output��
%   h:��̬���߶�̬��������ͳ�Ʒ������������
%   p����̬���߶�̬��������ͳ�Ʒ�����pֵ

%% All inputs

if nargin <1
    % fc
    path_sz='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\state1_SZ';
    path_bd='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\state1_BD';
    path_mdd='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\state1_MDD';
    path_hc='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\state1_HC';
    
    suffix='*.mat';
    n_row=114;%�����м���
    n_col=114;%�����м���

    % cov
    path_sz_cov='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\cov\state1_cov_SZ.xlsx';
    path_bd_cov='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\cov\state1_cov_BD.xlsx';
    path_mdd_cov='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\cov\state1_cov_MDD.xlsx';
    path_hc_cov='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\cov\state1_cov_HC.xlsx';
        
    % mask
    mask=ones(114,114);
    mask(triu(mask)==1)=0;
    mask=mask==1;
    
    % correction
    fdr_threshold=0.05;
    correction_method='fdr';

    % save 
    if_save=1;
    save_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result';
end

% create folder to save results
if ~exist(save_path,'dir')
    mkdir(save_path);
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
fprintf('Loading covariance...\n');
cov_sz=load_cov(path_sz_cov);
cov_bd=load_cov(path_bd_cov);
cov_mdd=load_cov(path_mdd_cov);
cov_hc=load_cov(path_hc_cov);
Covariates={cov_sz,cov_bd,cov_mdd,cov_hc};
fprintf('Loaded covariance\n');

%% ׼������
% ��ȡID_Mask�ڵ�����,��ȡ֮�󣬱��Ծ��󽫻���1D����ʽ
fc_sz=fc_sz(:,mask);
fc_bd=fc_bd(:,mask);
fc_mdd=fc_mdd(:,mask);
fc_hc=fc_hc(:,mask);

% Inf/NaN to 1 and 0
fc_sz(isinf(fc_sz))=1;
fc_bd(isinf(fc_bd))=1;
fc_mdd(isinf(fc_mdd))=1;
fc_hc(isinf(fc_hc))=1;

fc_sz(isnan(fc_sz))=0;
fc_bd(isnan(fc_bd))=0;
fc_mdd(isnan(fc_mdd))=0;
fc_hc(isnan(fc_hc))=0;

%% ancova
DependentFiles={fc_sz,fc_bd,fc_mdd,fc_hc};
[fvalue_ancova,pvalue_ancova]=ancova(DependentFiles, Covariates);

%% multi-correction
if strcmp(correction_method,'fdr')
    results=multcomp_fdr_bh(pvalue_ancova,'alpha', fdr_threshold);
else
    results=multcomp_bonferroni(P,'alpha', fdr_threshold);
end
h_corrected=results.corrected_h;

%% let h_fdr and p_fdr back to original matrix
h_ancova_fdr=zeros(size(mask));
h_ancova_fdr(mask)=h_corrected;

F1=zeros(size(mask));
F1(mask)=fvalue_ancova;
fvalue_ancova=F1;

P1=zeros(size(mask));
P1(mask)=pvalue_ancova;
pvalue_ancova=P1;

%% save 
if if_save
    disp('save results...');
    save (fullfile(save_path,['h_ancova_',correction_method,'.mat']),'h_ancova_fdr');
    save (fullfile(save_path,['fvalue_ancova_',correction_method,'.mat']),'fvalue_ancova');
    save (fullfile(save_path,['pvalue_ancova_',correction_method,'.mat']),'pvalue_ancova');
    disp('saved results');
end

fprintf('==================================\n');
fprintf('Completed\n');
end

%% =================================================================
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

function cov=load_cov(path)
try
    cov=importdata(path);
catch
    cov=xlsread(path);
end
end

function [F,P]=ancova(DependentFiles, Covariates)
% ���Ԥ�����
disp('performing ancova for all dependent variables...')
n_x=size(DependentFiles{1},2);
n_g=length(DependentFiles);

% Ԥ����
fc=(DependentFiles{1});
n_features=size(fc,2);
F=zeros(1,n_features);
P=zeros(1,n_features);

for i=1:n_x
    dependentFiles={};
    for j=1:n_g
        dependentFiles=cat(2,dependentFiles,DependentFiles{j}(:,i));
    end
    [F(i),P(i)] = My_gretna_ANCOVA1(dependentFiles, Covariates);
end
end