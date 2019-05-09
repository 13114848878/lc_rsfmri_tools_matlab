function lc_fetchSubjStateFC(IDX,k,dFCPath,subj_name,out_path)
% ����kmeans���IDX�Լ����б��ԵĶ�̬���Ӿ���nNode*nNode*nWindow*nSubj��
% �����ÿ���˵ĸ���״̬�����Ӿ���״̬�����д�����λ��median/ƽ����mean,Ĭ����λ����
% ����ĳЩ����û��ĳ��״̬��DOI:10.1002/hbm.23430��
% input
    % IDX:kmeans���index
    % k:����
    % dFCPath:��̬�������Ӿ��������ļ��У�nNode*nNode*nWindow*nSubj��
    % subjName:���б��Ե����֣�˳��Ҫһ��
    % outPath:�������·��
% output
    % ÿ�����Ը��壬ÿ��״̬�����Ӿ���
%%
if nargin<1
    IDX_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\IDX.mat';
    k=4;
    dFCPath='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\DynamicFC_length17_step1_screened';
    subj_name='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\covariances\subjName.mat';
    out_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state4_all';
    
    IDX=importdata(IDX_path);
    subj_name=importdata(subj_name);
end
%%
% �½����������ļ���
for i=1:k
    if ~exist(fullfile(out_path,['state',num2str(i)]),'dir')
        mkdir(fullfile(out_path,['state',num2str(i)]));
    end
end

% ����˳����ر��Ե�����
% subj_name=importdata(subj_name);
numOfSubj=length(subj_name);

% �ж�����IDX\subj_name�Ƿ���ȷ�����Զ����㴰����Ŀ
[nRow,~]=size(IDX);
if fix(nRow/numOfSubj)~=nRow/numOfSubj
    fprintf('����Ĵ�����Ŀ*������Ŀ������IDX��\n');
    return
else
    num_window=nRow/numOfSubj;
end

% ���ر��ԵĶ�̬�������Ӿ���
dFCFile=dir(fullfile([dFCPath,'\*.mat']));
dFCName={dFCFile.name}';
dFCFile=fullfile(dFCPath,dFCName);

% ������ԣ������״̬��ƽ������
numOfSubj=length(subj_name);
ind_start=1:num_window:nRow;
ind_end=num_window:num_window:nRow;

% try
% p = parpool('local',1);
% catch
%     disp('�ѿ�����CPU')
% end

tic;
for ithSubj=1:numOfSubj
    fprintf('%d/%d\n',ithSubj,numOfSubj);
    calc_median_or_mean(IDX,ithSubj,ind_start,ind_end,dFCFile,subj_name,out_path);
end
toc;
fprintf('============Done!============\n');
end

function state_fc=calc_median_or_mean(IDX,ithSubj,ind_start,ind_end,dFCFile,subj_name,out_path)

idx_current_subj=IDX(ind_start(ithSubj):ind_end(ithSubj));
unique_idx=unique(idx_current_subj);
% ��ǰ���Ե�����״̬
dFC=importdata(dFCFile{ithSubj});%  ���뵱ǰ����
for i=1:length(unique_idx)
    % ��ƥ�䵱ǰ״̬�Ĵ��ڵĹ������ӵ�ƽ��ֵ
    ith_state=unique_idx(i);
    state_fc=median(dFC(:,:,idx_current_subj==ith_state),3);
%     state_fc=mean(dFC(:,:,idx_current_subj==ith_state),3);
    % ����ǰ������浽��ǰ���Եĵ�ǰ״̬�ļ�������
    outpath=fullfile(out_path,['state',num2str(ith_state)],subj_name{ithSubj});
    my_save(outpath,state_fc)
end
end

function my_save(outpath,state_fc)
save(outpath,'state_fc');
end