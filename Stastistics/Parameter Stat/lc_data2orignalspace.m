function mat2D=lc_data2orignalspace(mat1D,mask)
% ��1D���������ȡmask���ص�2Dԭʼ����
% mat1D ��ά�ȿ�����n_group*n_features
[n_g,n_f]=size(mat1D);
mat2D=zeros(n_g,size(mask,1),size(mask,2));
for i=1:n_g
    mat2D(i,mask)=mat1D(i,:);
end
mat2D = squeeze(mat2D);
end