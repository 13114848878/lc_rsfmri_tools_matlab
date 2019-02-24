function lc_circleplot(net_path,mask_path,how_disp,if_binary,which_group,if_save,save_name,net_index_path,node_name_path)
% ��;����circle����ʽ�������������Ӿ���
% input
%   net_path:��·���Ĺ������������ļ���
%   mask: ��·����mask�ļ���
%   how_disp����ʾ�����Ǹ�
%   only_disp_consistent:�Ƿ�ֻ��ʾ�����������һ�µ�����
%   which_group:��ʾ��һ����
%%
if nargin<1
    net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\tvalue_posthoc_fdr.mat';
    mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state4\result\distinct_3_fdr.mat';
    how_disp='all';% or 'only_neg'
    if_binary=1; %��ֵ��������ֵΪ1����ֵΪ-1
    which_group=1;
    if_save=0;
    save_name='state4_distinct_3';
    
    % ����index·���������ع��������磨���������˳��
    net_index_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\netIndex.mat';
    % �ڵ�����
    node_name_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\17network_label.xlsx';
    
end

% net
if strcmp(class(net_path),'char')
    net=importdata(net_path);
else 
    net=net_path;
end

% ��ʾ�����߸�
if strcmp(how_disp,'only_pos')
    net(net<0)=0;%ֻ��ʾ��
elseif strcmp(how_disp,'only_neg')
    net(net>0)=0;%ֻ��ʾ��
elseif strcmp(how_disp,'all')
    disp('���͸�����ʾ')
else
    disp('��ָ����ʾ�����Ǹ�!')
    return
end


% ��ʾ��һ��
if numel(size(net))>1
    net=squeeze(net(which_group,:,:));
end

% ��ֵ������
if if_binary
    net(net<0)=-1;
    net(net>0)=1;
end

% mask
if strcmp(class(mask_path),'char')
    mask=importdata(mask_path);
else
    mask=mask_path; 
end

% ɸѡmask����һ���mask��
if numel(size(mask))==3
    mask=squeeze(mask(1,:,:));
end

% ��mask�ڵ�����
net=net.*mask;

% �������绮�֣�������֯net
net_index=importdata(net_index_path);
[index,re_net_index,re_net]=lc_ReorganizeNetForYeo17NetAtlas(net,net_index);

% �ڵ�����,��������������֯�ڵ�����
[~,node_name]=xlsread(node_name_path);
node_name=node_name(index,:);


% Create custom node labels
myLabel = cell(length(re_net));
[ind_i,ind_j,index_nozero]=find(re_net);
for i = 1:length(myLabel)
%     myLabel{i,1} = num2str(index(i));
    myLabel{i,1} = '';
end
% for i=1:length(index_nozero)
%     myLabel{ind_i(i)} =node_name{ind_i(i),2};
%     myLabel{ind_j(i)} =node_name{ind_j(i),2};
% end

% Create custom colormap
color=jet(7); % lines��hsv
color(color==1)=color(color==1)-0.3;
color(color==0)=color(color==0)+0.2;
color(2,:)=[1 0 1];
color1=color(7,:);
color(7,:)=[0.67 0 0.8];
color(1,:)=color1;
for i=1:114
    myColorMap(i,:)=color(re_net_index(i),:);
end

% plot circle
% figure;
circularGraph(re_net,'Colormap',myColorMap,'Label',myLabel);

% save
if if_save
%     set(gcf,'outerposition',get(0,'screensize'));
    print(gcf,'-dtiff', '-r300',save_name)
end
end