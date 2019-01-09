function [shared_1and2and3,shared_1and2,shared_1and3,shared_2and3,...
          distinct_1,distinct_2,distinct_3]=...
                lc_calc_shared_and_distinct_for_FCmatrix(h_mat)
% ����post-hoc֮���ҵ������飨������������˵����ͬ�Լ�������쳣����
% SZ & BD & MDD��SZ & BD not MDD��SZ & MDD not BD��BD & MDD not SZ��SZ��BD��MDD
% input
%   H_mat: ����post-hoc ˫����t����+FDRУ�����H����H==1,��ʾ��ͳ��ѧ���壩
%%
if nargin<1
    % input
    path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all';
    state=4;
    correction_method='fdr';
    
    %
    h_posthoc_corrected=fullfile(path,['state',num2str(state),'\result','\h_posthoc_',correction_method,'.mat']);
    h_mat=importdata(h_posthoc_corrected);
    if_save=1;
    save_path=fullfile(path,['state',num2str(state),'\result']);
end
% ��ͬ��������쳣���ӣ����о���3�ּ�������˹�ͬ����3���Լ�2�������Ĺ�ͬ��
sum_h_mat=squeeze(sum(h_mat));
shared_1and2and3=sum_h_mat==3; %3�߹�ͬ
[shared_1and2,shared_1and3,shared_2and3]=calc_com2(sum_h_mat,h_mat); %2�߹�ͬ
[distinct_1,distinct_2,distinct_3]=calc_special(sum_h_mat,h_mat); %ÿ�ּ�������

% save
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

function [com_1and2,com_1and3,com_2and3]=calc_com2(sum_h_mat,h_mat)
% ����3�ּ���ʱ��������������2�������Ĺ�ͬ���죨���ҽ���2�ֹ�ͬ��
% input
%   sum_h_mat: �����ά�ȶ�H������͵Ľ������

com_2disorder=sum_h_mat==2;

com_1and2=com_2disorder.*squeeze(h_mat(1,:,:)).*squeeze(h_mat(2,:,:));
com_1and3=com_2disorder.*squeeze(h_mat(1,:,:)).*squeeze(h_mat(3,:,:));
com_2and3=com_2disorder.*squeeze(h_mat(2,:,:)).*squeeze(h_mat(3,:,:));
end

function [distinct_1,distinct_2,distinct_3]=calc_special(sum_h_mat,h_mat)
% ����3�ּ���ʱ������ÿһ�ּ���������쳣����
% input
%   sum_h_mat: �����ά�ȶ�H������͵Ľ������

distinct=sum_h_mat==1;

distinct_1=distinct.*squeeze(h_mat(1,:,:));
distinct_2=distinct.*squeeze(h_mat(2,:,:));
distinct_3=distinct.*squeeze(h_mat(3,:,:));
end