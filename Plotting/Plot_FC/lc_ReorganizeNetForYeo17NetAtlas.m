function [index,sortedNetIndex,reorgNet]=lc_ReorganizeNetForYeo17NetAtlas(net,netIndex)
% ��Yeo17����ģ������������ıߣ����ϵ����ڵ�������
% input:
%   net:һ���ԳƵ���ؾ���
%   netIndex:������ÿ���ڵ������index������Yeo��17����ģ���Ӧ��114����������ôÿ��������Ӧ��һ������
%   ��ô��Ӧ���Ǹ������index��Ϊ��index
% output:
%   index:������������ԭʼ�����е�index
%   sortedNetIndex: ����������˳��
%   reorgNet:����������
%% fetch netIndex
% �Ժ�netIndex ʱ��ֱ��load
if nargin<2
    netIndex=importdata('D:\My_Codes\Github_Related\Github_Code\Template_Yeo2011\netIndex.mat');
end
% sepIndex=[5,10,17,28,30,44,57,57+[5,10,17,28,30,44 57]];
% indexForNet=[0,sepIndex];
% netIndex=zeros(1,length(net));
% for i=1:length(sepIndex)
%     index=indexForNet(i)+1:indexForNet(i+1);
%     netIndex(index)=i;
% end
% %����57��������ǰ������ͬһ��������
% netIndex(58:end)=netIndex(1:57);
% save('netIndex.mat','netIndex')
%% reorganize net
[sortedNetIndex,index]=sort(netIndex);
reorgNet=net(index,index);
% reorgNet1=reorgNet(sortedNetIndex==4|sortedNetIndex==6|sortedNetIndex==7,...
%                    sortedNetIndex==4|sortedNetIndex==6|sortedNetIndex==7);
end