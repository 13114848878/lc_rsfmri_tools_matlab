%����ȫ�Եı�����(�źŵķ���)
clear
clc
path=('E:\wangfeidata\RealignParameter');
maskdata=rest_ReadNiftiImage('E:\allcode\GS\GreyMask_02_61x73x61.img');
out=('E:\wangfeidata\Var');
ind=find(maskdata);
temp=dir(path);
temp=temp(3:end);
for i=1:length(temp)
    i
    tt=[path,temp(i).name];
    tt=dir([tt,filesep,'*nii']);
    [tdata,head] =rest_ReadNiftiImage([path,temp(i).name,'\',tt.name]);
    tdata=reshape(tdata,61*73*61,size(tdata,4));%������Ͼ�
    for j=1:size(tdata,1)
        result(j)=var(tdata(j,:));
    end
    result=reshape(result,[61,73,61]);
    rest_WriteNiftiImage(result,head,[out,temp(i).name]);
end
    