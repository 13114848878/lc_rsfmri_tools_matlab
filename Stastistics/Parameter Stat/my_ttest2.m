function [H,P,T]=my_ttest2(DependentFiles,contrast)
% ���������������������������Ա�
% �����ܹ���4�飬���������ڵ����飬��
% contrast=[1 1 1 0]
n_g=sum(contrast);
patients_groups_ind=find(contrast==1);

% Ԥ����
fc=(DependentFiles{1});
n_features=size(fc,2);
H=zeros(n_g,n_features);
P=zeros(n_g,n_features);

for i=1:n_g
    [H(i,:),P(i,:),~,S(i,:)] = ttest2(DependentFiles{patients_groups_ind(i)}, DependentFiles{contrast==0});
end
T={S.tstat}';
T=cell2mat(T);
end