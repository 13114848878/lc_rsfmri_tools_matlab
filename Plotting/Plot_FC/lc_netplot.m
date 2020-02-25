function lc_netplot(net_path,if_add_mask,mask_path,how_disp,if_binary,which_group,net_index_path, is_legend, legends)
% Use: plot matrix with sorted according to network order
% input
%   net_path:��·���Ĺ������������ļ���
%   mask: ��·����mask�ļ���
%   how_disp����ʾ�����Ǹ�
%   which_group:��ʾ��һ����
%%
if nargin<1
    net_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\tvalue_posthoc_fdr.mat';
    mask_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all\state1\result\h_posthoc_fdr.mat';
    if_add_mask=1;
    how_disp='all'; % or 'only_neg'
    if_binary=0; 
    which_group=1;
    net_index_path='D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\netIndex.mat';
end

% net
if isa(net_path, 'char')
    net=importdata(net_path);
else 
    net=net_path;
end

% show postive and/or negative
if strcmp(how_disp,'only_pos')
    net(net<0)=0;  
elseif strcmp(how_disp,'only_neg')
    net(net>0)=0;  
elseif strcmp(how_disp,'all')
    disp('show both postive and negative')
else
    disp('Did not specify show positive or negative!')
    return
end

% when matrix is 3D, show which (the 3ith dimension)
if numel(size(net))==3
%     net=squeeze(net(which_group,:,:));
    net=squeeze(net(:,:,which_group));
end

% transfer the weighted matrix to binary
if if_binary
    net(net<0)=-1;
    net(net>0)=1;
end

% mask
if if_add_mask
    if isa(mask_path, 'char')
       mask=importdata(mask_path);
    else
        mask=mask_path;
    end
    
    % when mask is 3D, show which (the 3ith dimension)
    if numel(size(mask))==3
        mask=squeeze(mask(which_group,:,:));
    end
    
    % extract data in mask
    net=net.*mask;
end

% sort the matrix according to network index
net_index=importdata(net_index_path);
[index,re_net_index,re_net]=lc_ReorganizeNetForYeo17NetAtlas(net,net_index);

% plot: insert separate line between each network
lc_InsertSepLineToNet(re_net, re_net_index, 0.4, is_legend, legends);
% axis square
end

function lc_InsertSepLineToNet(net, network_index, linewidth, is_legend, legends)
% �˴���Ĺ��ܣ���һ����������ֲ�������ָ��ߣ��Լ�bar
% �˷ָ��߽���ͬ��������ֿ�
% ��ͬ��ɫ�����򣬴���һ����ͬ������
% input
%   net:һ���������N*N,NΪ�ڵ����������Ϊ�Գƾ���
%   network_index: network index of each node.
%   location_of_sep:�ָ��ߵ�index��Ϊһ������������[3,9]��ʾ����ָ��߷ֱ�λ��3��9����
%% input
% if not given location_of_sep, then generate it using network_index;
uni_id = unique(network_index);
location_of_sep = [0; cell2mat(arrayfun( @(id) max(find(network_index == id)), uni_id, 'UniformOutput',false))];

if size(net,1)~=size(net,2)
    error('Not a symmetric matrix!\n');
end

%%
n_node = length(net);
imagesc(net);

% insert separate line
lc_line(location_of_sep, n_node, linewidth);
hold on;

% bar region
extend = n_node / 10;
xlim([-extend, n_node]);
ylim([0, n_node + extend]);
lc_bar_region_of_each_network(location_of_sep, n_node, extend, is_legend, legends);
axis off
end