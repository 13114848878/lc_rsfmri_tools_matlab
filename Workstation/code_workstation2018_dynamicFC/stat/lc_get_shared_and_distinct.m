function [shared_1and2and3,shared_1and2,shared_1and3,shared_2and3,...
          distinct_1,distinct_2,distinct_3]=...
                lc_get_shared_and_distinct(h_mat,t_mat)
% ����post-hoc֮���ҵ������飨������������˵����ͬ�����쳣����һ�£��Լ�ÿ�ּ������еģ��������쳣�������У��쳣����
% SZ & BD & MDD��SZ & BD not MDD��SZ & MDD not BD��BD & MDD not SZ��SZ��BD��MDD
% input
%   h_mat: ����post-hoc ˫����t����+FDRУ�����H����H==1,��ʾ��ͳ��ѧ���壩
%   t_mat: ����post-hoc ˫����t�����tֵ
%%
if nargin<1
    % input
    rootpath='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all';
    state=4;
    correction_method='fdr';

    h_posthoc_corrected=fullfile(rootpath,['state',num2str(state),'\result','\h_posthoc_',correction_method,'.mat']);
    t_posthoc_corrected=fullfile(rootpath,['state',num2str(state),'\result','\tvalue_posthoc_',correction_method,'.mat']);
    h_mat=importdata(h_posthoc_corrected);
    t_mat=importdata(t_posthoc_corrected);
    if_save=1;
    save_path=fullfile(rootpath,['state',num2str(state),'\result1']);
end

% �½�����ļ���
mkdir(save_path)
%% ��ͬ�����е��쳣���ӣ����о���3�ּ�������˹�ͬ����3���Լ�2�������Ĺ�ͬ��

% 3�߹�ͬ����ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
sum_h_mat=squeeze(sum(h_mat));
shared_1and2and3_ahad=sum_h_mat==3; 
tvalue_sign_for_1and2and3=sign(t_mat);
tvalue_sum=abs(squeeze(sum(tvalue_sign_for_1and2and3,1)));
tvalue_sign_comparisonor=ones(size(tvalue_sum))*size(tvalue_sign_for_1and2and3,1);
mask_net=tvalue_sum==tvalue_sign_comparisonor;
shared_1and2and3=shared_1and2and3_ahad.*mask_net~=0;

% 2�߹�ͬ����ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
[shared_1and2,shared_1and3,shared_2and3]=calc_shared2(sum_h_mat,h_mat,t_mat); 

% ÿ�ּ������У���ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
[distinct_1,distinct_2,distinct_3]=calc_distinct(sum_h_mat,h_mat); 

%% save
if if_save
    save(fullfile(save_path,['shared_1and2and3_',correction_method,'.mat']),'shared_1and2and3');
    save(fullfile(save_path,['shared_1and2_',correction_method,'.mat']),'shared_1and2');
    save(fullfile(save_path,['shared_1and3_',correction_method,'.mat']),'shared_1and3');
    save(fullfile(save_path,['shared_2and3_',correction_method,'.mat']),'shared_2and3');
    
    save(fullfile(save_path,['distinct_1_',correction_method,'.mat']),'distinct_1');
    save(fullfile(save_path,['distinct_2_',correction_method,'.mat']),'distinct_2');
    save(fullfile(save_path,['distinct_3_',correction_method,'.mat']),'distinct_3');
end
end

function [shared_1and2,shared_1and3,shared_2and3]=calc_shared2(sum_h_mat,h_mat,t_mat)
% ����3�ּ���ʱ��������������2�������Ĺ�ͬ���죨���ҽ���2�ֹ�ͬ��
% input
%   sum_h_mat: �����ά�ȶ�H������͵Ľ������
%%
% 1and2
shared_2disorder=sum_h_mat==2;
shared_1and2_ahad=shared_2disorder.*squeeze(h_mat(1,:,:)).*squeeze(h_mat(2,:,:));

t_mat_for_1and2=t_mat(1:2,:,:);
tvalue_sign=sign(t_mat_for_1and2);
tvalue_sum=abs(squeeze(sum(tvalue_sign,1)));
tvalue_sign_comparisonor=ones(size(tvalue_sum))*size(tvalue_sign,1);
mask=tvalue_sum==tvalue_sign_comparisonor;
shared_1and2=shared_1and2_ahad.*mask~=0;

% 1and3
shared_1and3_ahad=shared_2disorder.*squeeze(h_mat(1,:,:)).*squeeze(h_mat(3,:,:));
t_mat_for_1and3=t_mat([1,3],:,:);
tvalue_sign=sign(t_mat_for_1and3);
tvalue_sum=abs(squeeze(sum(tvalue_sign,1)));
tvalue_sign_comparisonor=ones(size(tvalue_sum))*size(tvalue_sign,1);
mask=tvalue_sum==tvalue_sign_comparisonor;
shared_1and3=shared_1and3_ahad.*mask~=0;

% 2and3
shared_2and3_ahad=shared_2disorder.*squeeze(h_mat(2,:,:)).*squeeze(h_mat(3,:,:));
t_mat_for_2and3=t_mat([2,3],:,:);
tvalue_sign=sign(t_mat_for_2and3);
tvalue_sum=abs(squeeze(sum(tvalue_sign,1)));
tvalue_sign_comparisonor=ones(size(tvalue_sum))*size(tvalue_sign,1);
mask=tvalue_sum==tvalue_sign_comparisonor;
shared_2and3=shared_2and3_ahad.*mask~=0;
end

function [distinct_1,distinct_2,distinct_3]=calc_distinct(sum_h_mat,h_mat)
% ����3�ּ���ʱ������ÿһ�ּ���������쳣����(�����Ƿ���һ�µ����в���)
% input
%   sum_h_mat: �����ά�ȶ�H������͵Ľ������
%   h_mat��H����

distinct=sum_h_mat==1;

distinct_1=distinct.*squeeze(h_mat(1,:,:));
distinct_2=distinct.*squeeze(h_mat(2,:,:));
distinct_3=distinct.*squeeze(h_mat(3,:,:));
end