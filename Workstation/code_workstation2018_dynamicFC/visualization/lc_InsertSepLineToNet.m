function lc_InsertSepLineToNet(net,network_index, location_of_sep)
% �˴���Ĺ��ܣ���һ����������ֲ�������ָ��ߣ��˷ָ��߽���ͬ��������ֿ�
% input
%   net:һ���������N*N,NΪ�ڵ����������Ϊ�Գƾ���
%   network_index: network index of each node.
%   location_of_sep:�ָ��ߵ�index��Ϊһ������������[3,9]��ʾ����ָ��߷ֱ�λ��3��9����
%% input
if nargin < 3
    % if not given location_of_sep, then generate it using network_index;
    uni_id = unique(network_index);
    location_of_sep = [0; cell2mat(arrayfun( @(id) max(find(network_index == id)), uni_id, 'UniformOutput',false))];
%     sepIndex=importdata('D:\WorkStation_2018\WorkStation_dynamicFC_V2\Data\Network_and_plot_para\sepIndex.mat');
end

if size(net,1)~=size(net,2)
    error('Not a symmetric matrix!\n');
end

%%
% figure
% figure;
imagesc(net)
% insert separate line
lc_line(location_of_sep,length(net))
axis off
end

function lc_line(sepIndex,nNode)
% nNode: node����
for i=1:length(sepIndex)
    line([sepIndex(i)+0.5,sepIndex(i)+0.5],[-10,nNode*2],'color','k','LineWidth',0.8)
    line([0,nNode*2],[sepIndex(i)+0.5,sepIndex(i)+0.5],'color','k','LineWidth',0.8)
end
end