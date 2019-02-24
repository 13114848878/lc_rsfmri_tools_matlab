%% �������������(shared)
% ע��Ҫ���ǲ���ķ���
% ����SZ��ĳ������С�������ˣ���BD�Ĵ����Ӵ��������ˣ�������ڷ���һ�¡�
% �������Ѿ����ǵ����������
% �������������Ҫ�������ۡ����о�������������ټ���
%% input
if_binary=1; %��ֵ��������ֵΪ1����ֵΪ-1
net_index_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\netIndex.mat';
node_name_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\17network_label.xlsx';
if_save=0;
save_name='';
how_disp='all';% or 'only_neg'

% ��ʼ��ͼ
figure
set(gcf,'Position',get(0,'ScreenSize'))
% set(gcf,'outerposition',get(0,'screensize'));
ha = tight_subplot(3,4,[0.05 0.01],[0.01 0.01],[0.01 0.01]);

% ״̬1
axes(ha(1)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\shared_1and2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(2)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\shared_1and2_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(3)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\shared_1and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=3;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(4)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\shared_2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=2;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)


% ״̬2
axes(ha(5)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\shared_1and2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(6)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\shared_1and2_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(7)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\shared_1and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=3;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(8)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state2\result\shared_2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=2;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)


% ״̬4
axes(ha(9)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\shared_1and2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(10)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\shared_1and2_fdr.mat';


% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;

which_group=1;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(11)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\shared_1and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;


which_group=3;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

axes(ha(12)); 
net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\tvalue_posthoc_fdr.mat';
mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\shared_2and3_fdr.mat';

% ֻѡ���쳣����һ�µ�����(mask��mask_sign�Ľ���)
net=importdata(net_path);
mask=importdata(mask_path);
net_sign=sign(net);
net_sum=abs(squeeze(sum(net_sign,1)));
net_sign_comp=ones(size(net_sum))*size(net_sign,1);
mask_net=net_sum==net_sign_comp;
mask_path=mask.*mask_net~=0;


which_group=2;
lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)

%
set(gcf,'color','k');
set(ha(1:4),'XTickLabel',''); 
set(ha,'YTickLabel','')

% save
if if_save
%     set(gcf,'outerposition',get(0,'screensize'));
    print(gcf,'-dtiff', '-r300','D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\figure\shared_all3.tiff')
end