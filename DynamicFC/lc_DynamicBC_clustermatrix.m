function lc_DynamicBC_clustermatrix(k,subjdir,output,CluMet)
% �Զ�̬�������Ӿ�����о���
% ���������DynamicBC
% �˴����Լ������޸ģ�
    % 1��ֻ���������Ǿ��󣨲������Խ��ߣ�
    % 2��ֻʹ����ˮƽ�ľ��������Ӷ�����ĳЩ����ȱ��ĳЩ״̬�����Ǻܶ��о������
%% ============================����=================================
% k=5;
% subjdir='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\DynamicFC_length17_step1_screened';
% output='D:\WorkStation_2018\WorkStation_2018_08_Doctor_DynamicFC_Psychosis\Data\zDynamic\state_test'
% CluMet='cityblock';
%% =================================================================
subFold = dir(fullfile(subjdir,'*.mat'));
% save subjName
subjName={subFold.name}';
mkdir(output);
save(fullfile(output,'subjName.mat'),'subjName');
%
nSubj = size(subFold,1);
% pre-allocating space
filaName=fullfile(subjdir,subFold(1).name);
dynamicMats=importdata(filaName);
nNode=size(dynamicMats,1);
nWindow = length(dynamicMats);
upMatMask=triu(ones(nNode,nNode),1)==1;%�����Ǿ���mask
nFeature=sum(upMatMask(:));
mat_of_one_state=zeros(nFeature,nWindow);
all_mat = zeros(nFeature,nWindow,nSubj);
for i = 1:nSubj
    fprintf('load %dth dynamic matrix to all matrix\n',i);
   % if isfile(fullfile(subjdir,subFold(i+2).name))
        filaName=fullfile(subjdir,subFold(i).name);
        dynamicMats=importdata(filaName);
        % ע�⣺Ϊ�˽�Լ����ɱ�����ֻ��ȡÿһ��FC�������Ǿ���
        % ���ڶԽ���û�о��๦�ܣ���˲������Խ���
        for imat = 1:nWindow
            upMat=dynamicMats(:,:,imat);
            upMat=upMat(upMatMask);
            mat_of_one_state(:,imat)=upMat;
        end
        all_mat(:,:,i) = mat_of_one_state;
    %end
end
fprintf('======loaded all mat!======\n')
%% kmeans
fprintf('This process will take a while!\nWaiting for kmeans clustering...\n');
all_mat(isinf(all_mat))=1;
all_mat(isnan(all_mat))=0;
all_mat=reshape(all_mat,nFeature,nWindow*nSubj)';
% ���������ģ��������󽫻�ǳ���ʱ,��ʹ�ø����ܼ�����������ĵȴ�
opts = statset('Display','final');
[index_of_state,C,sumd,D] = kmeans(all_mat,k,'Distance',CluMet,'Replicates',100,'Options',opts);

fprintf('getting and saving all subjects'' median network during each state...\n')
for i = 1:k
    ind = index_of_state==i;
    mat_of_one_state=all_mat(ind,:);
    median_mat = median(mat_of_one_state,1);
    square_median_mat=eye(nNode);
    square_median_mat(upMatMask)=median_mat;
    square_median_mat=square_median_mat+square_median_mat';
    square_median_mat(eye(nNode)==1)=1;
    save(fullfile(output,['Cluster_',num2str(i),'.mat']),'square_median_mat');
end

fprintf('saving meta info...\n');
save(fullfile(output,'index_of_state.mat'),'index_of_state');
save(fullfile(output,'C.mat'),'C');
save(fullfile(output,'sumd.mat'),'sumd');
save(fullfile(output,'D.mat'),'D');
fprintf('============Done!============\n');
end

