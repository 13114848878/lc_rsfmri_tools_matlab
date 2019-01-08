function fetchSubjStateFC(IDX,k,dFCPath,subjName,outPath)
% ����kmeans���IDX�Լ����б��ԵĶ�̬���Ӿ���nNode*nNode*nWindow*nSubj��
% �����ÿ���˵ĸ���״̬�����Ӿ���״̬�����д���ƽ����
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
% dFCPath='D:\WorkStation_2018\WorkStation_2018_08_Doctor_DynamicFC_Psychosis\Data\zDynamic\DynamicFC_length17_step1_screened';
% k=2;
% outPath='D:\WorkStation_2018\WorkStation_2018_08_Doctor_DynamicFC_Psychosis\Data\zDynamic\state\allState17_2';
%%
%%
[nRow,~]=size(IDX);
if fix(nRow/numOfSubj)~=nRow/numOfSubj
    fprintf('����Ĵ�����Ŀ*������Ŀ��IDX��һ�£�\n');
    return
else
    numOfWindow=nRow/numOfSubj;
end
%% load dFC
dFCFile=dir(fullfile([dFCPath,'\*.mat']));
dFCName={dFCFile.name}';
dFCPath=dFCFile.folder;
dFCFile=fullfile(dFCPath,dFCName);
%%
numOfSubj=length(subjName);
for ithState=1:k
    outpath=fullfile(outPath,['state',num2str(ithState)]);
    mkdir(outpath);
    fprintf('%d/%d\n',ithState,k);
    %
    startInd=1;
    endInd=numOfWindow;
    for ithSubj=1:numOfSubj
        fprintf('%d/%d\n',ithSubj,numOfSubj);
        idx=IDX(startInd:endInd);
        if ithState<=max(idx)
            dFC=importdata(dFCFile{ithSubj});
            stateFC=mean(dFC(:,:,idx==ithState),3);%ƽ��
            % save
            save(fullfile(outpath,subjName{ithSubj}),'stateFC')
        end
        startInd=startInd+numOfWindow;
        endInd=endInd+numOfWindow;
    end
end
end