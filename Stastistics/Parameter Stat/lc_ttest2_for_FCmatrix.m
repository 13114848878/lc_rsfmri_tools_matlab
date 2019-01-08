function  [tValue, p, p_fdr, h_fdr]=lc_ttest2_for_FCmatrix(ID_Mask,fdr_threshold)
% ��ROI wise��static/dynamic FC ����ͳ�Ʒ���(ttest2+fdr)
%%input��
%   ZFC_*��ROI wise�ľ�̬�Ͷ�̬�������Ӿ���,size=N*N,NΪROI����
%   ID_Mask������ȤROI��id,ȱʡ������е����ӽ���ͳ��
% output��
%   h:��̬����̬��������ͳ�Ʒ������������
%   p����̬����̬��������ͳ�Ʒ�����pֵ
%% parameters
if nargin <2
    fdr_threshold=0.05;
end
%% ===========load all MAT files==========================
%��һ��
[file_name,path_source,~] = uigetfile({'*.mat;','All Image Files';...
    '*.*','All Files'},'MultiSelect','on','��һ�����');
if iscell(file_name)
    n_sub=length(file_name);
    mat_template=importdata([path_source,char(file_name(1))]);
else
    n_sub=1;
    mat_template=importdata([path_source,char(file_name)]);
end
mat_p=zeros(size(mat_template,1), size(mat_template,2),n_sub);
for i=1:n_sub
    if iscell(file_name)
        mat_p(:,:,i)=importdata([path_source,char(file_name(i))]);
    else
        mat_p(:,:,i)=importdata([path_source,char(file_name)]);
    end
end
%�ڶ���
[file_name,path_source,~] = uigetfile({'*.mat;','All Image Files';...
    '*.*','All Files'},'MultiSelect','on','�ڶ������');
if iscell(file_name)
    n_sub=length(file_name);
    mat_template=importdata([path_source,char(file_name(1))]);
else
    n_sub=1;
    mat_template=importdata([path_source,char(file_name)]);
end
mat_c=zeros(size(mat_template,1), size(mat_template,2),n_sub);
for i=1:n_sub
    if iscell(file_name)
        mat_c(:,:,i)=importdata([path_source,char(file_name(i))]);
    else
        mat_c(:,:,i)=importdata([path_source,char(file_name)]);
    end
end
fprintf('==================================\n');
fprintf('Load MAT files\n');
%%
% Ĭ�ϵ�ID_Mask
if nargin<1
    ID_Mask=1:size(mat_c,1);
end
%% ttest2 and fdr correction
% ��ȡID_Mask�ڵ�����
mat_p=mat_p(ID_Mask,ID_Mask,:);
mat_c=mat_c(ID_Mask,ID_Mask,:);
% Inf/NaN to 1 and 0
mat_p(isinf(mat_p))=1;
mat_c(isinf(mat_c))=1;
mat_p(isnan(mat_p))=0;
mat_c(isnan(mat_c))=0;
% ͳ��
[nNode,~,nSubj_P]=size(mat_p);
[~,~,nSubj_C]=size(mat_c);
mat_p=reshape(mat_p,nNode*nNode,nSubj_P)';
mat_c=reshape(mat_c,nNode*nNode,nSubj_C)';
[~,p,~,stats]=ttest2(mat_p,mat_c);
tValue=stats.tstat;
p=reshape(p',nNode,nNode);
tValue=reshape(tValue',nNode,nNode);
% �����ǣ��������Խ��ߣ���������ȡ
mask_triu=ones(size(p));
mask_triu(tril(mask_triu)==1)=0;
p_static_triu=p(mask_triu==1);
% fdr correction
results=multcomp_fdr_bh(p_static_triu,'alpha', fdr_threshold);
p_fdr=results.critical_alpha;
h_fdr=results.corrected_h;
% let h_fdr back to matrix
h_back=zeros(size(p));
h_back(mask_triu==1)=h_fdr;
h_fdr=h_back;
fprintf('==================================\n');
fprintf('Completed\n');
end