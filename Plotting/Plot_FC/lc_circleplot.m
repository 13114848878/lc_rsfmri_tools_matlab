function lc_circleplot(net_path,mask_path,how_disp,which_group)
% ��;����circle����ʽ�������������Ӿ���
% input
%   net_path:��·���Ĺ������������ļ���
%   mask: ��·����mask�ļ���
%   how_disp����ʾ�����Ǹ�
%   which_group:��ʾ��һ����
%%
if nargin<1
    net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
    mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\shared_2and3_fdr.mat';
    how_disp='all';% or 'only_neg'
    if_binary=1; %��ֵ��������ֵΪ1����ֵΪ-1
    which_group=2;
    
    % ����index·���������ع��������磨���������˳��
    net_index_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\netIndex.mat';
    % �ڵ�����
    node_name_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\17network_label.xlsx';
end

% net
net=importdata(net_path);

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
if numel(size(net))==3
    net=squeeze(net(which_group,:,:));
end

% ��ֵ������
if if_binary
    net(net<0)=-1;
    net(net>0)=1;
end

% mask
mask=importdata(mask_path);

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
    myLabel{i,1} = num2str(index(i));
    myLabel{i,1} = '';
end
% for i=1:length(index_nozero)
%     myLabel{ind_i(i)} =node_name{ind_i(i),3};
%     myLabel{ind_j(i)} =node_name{ind_j(i),3};
% end

% Create custom colormap
color=jet(7); % lines��hsv
color(2,:)=[1 0 1];
color1=color(7,:);
color(7,:)=[0.67 0 0.8];
color(1,:)=color1;
for i=1:114
    myColorMap(i,:)=color(re_net_index(i),:);
end

% plot circle
figure;
circularGraph(re_net,'Colormap',myColorMap,'Label',myLabel);
end