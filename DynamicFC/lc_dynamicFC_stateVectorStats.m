function stateVectorStats=lc_dynamicFC_stateVectorStats(IDX,k,subjName,numOfSubj,outPath)
% �˺����õ���gift���ִ��룬������
% �˺����������������˵�״̬����ָ�꣬���£�
% Fraction of time spent in each state
% Number of Transitions
% Mean dwell time in each state
% Full Transition Matrix
% input:
% IDX:���б��ԣ����д��ڶ�Ӧ��״̬index
% k:״̬��Ŀ
% subjName:���б��Ե����ƣ�һ��N*1��cell��˳�������IDX��Ӧ
% numOfWindow����̬���ڸ���
% numOfSubj�����Ը���
% output:
% stateVectorStats:���б���ÿ�����ڵ�state metrics��һ��structure��
%% =================================================================
[nRow,nCol]=size(IDX);
if fix(nRow/numOfSubj)~=nRow/numOfSubj
    fprintf('����Ĵ�����Ŀ*������Ŀ��IDX��һ�£�\n');
    return
else
    numOfWindow=nRow/numOfSubj;
end
if nCol~=1
    fprintf('IDX�ж��У�\n');
    return
end
%% =================================================================
% calculate state metrics
fprintf('calculating state metrics...\n')
F=zeros(numOfSubj,k);
TM=zeros(numOfSubj,k,k);
MDT=zeros(numOfSubj,k);
NT=zeros(numOfSubj,1);
startInd=1;
endInd=numOfWindow;
% make dir
mkdir(fullfile(outPath,'fractionOfTimeSpentInEachDtate'));
mkdir(fullfile(outPath,'fullTransitionMatrix'));
mkdir(fullfile(outPath,'meanDwellTimeInEachState'));
mkdir(fullfile(outPath,'numberOfTransitions'));
for i=1:numOfSubj
    fprintf('%d/%d\n',i,numOfSubj);
    idx=IDX(startInd:endInd);
    [f, tm, mdt, nt] = lc_icatb_dfnc_statevector_stats(idx, k);
    F(i,:)=f;
    TM(i,:,:)=tm;
    MDT(i,:)=mdt;
    NT(i)=nt;
    name=subjName{i};
    % save
    save(fullfile(outPath,'fractionOfTimeSpentInEachDtate',[name,'.mat']),'f');
    save(fullfile(outPath,'fullTransitionMatrix',[name,'.mat']),'tm');
    save(fullfile(outPath,'meanDwellTimeInEachState',[name,'.mat']),'mdt');
    save(fullfile(outPath,'numberOfTransitions',[name,'.mat']),'nt');
    % updata index
    startInd=startInd+numOfWindow;
    endInd=endInd+numOfWindow;
end
%% =================================================================
% save all state metrics in one file
stateVectorStats.fractionOfTimeSpentInEachDtate=F;
stateVectorStats.fullTransitionMatrix=TM;
stateVectorStats.meanDwellTimeInEachState=MDT;
stateVectorStats.numberOfTransitions=NT;
save(fullfile(outPath,'allStateVectorStats.mat'),'stateVectorStats')
%
fprintf('All Done!.\n')
end

function [F, TM, MDT, NT] = lc_icatb_dfnc_statevector_stats(a, k)
% ��gift���ƶ�����һ��Ҫ����
% input��
%     a:һ�����Ե����д���Ӧ��״̬,����[1 3 5 3 2 4]
%     k: ״̬����
%
%%

Nwin = length(a);

%% Fraction of time spent in each state
F = zeros(1,k);
for jj = 1:k
    F(jj) = (sum(a == jj))/Nwin;
end

%% Number of Transitions
NT = sum(abs(diff(a)) > 0);

%% Mean dwell time in each state
MDT = zeros(1,k);
for jj = 1:k
    start_t = find(diff(a==jj) == 1);
    end_t = find(diff(a==jj) == -1);
    if a(1)==jj
        start_t = [0; start_t];
    end
    if a(end) == jj
        end_t = [end_t; Nwin];
    end
    MDT(jj) = mean(end_t-start_t);
    if isempty(end_t) & isempty(start_t)
        MDT(jj) = 0;
    end
end

%% Full Transition Matrix
TM = zeros(k,k);
for t = 2:Nwin
    TM(a(t-1),a(t)) =  TM(a(t-1),a(t)) + 1;
end

for jj = 1:k
    if sum(TM(jj,:)>0)
        TM(jj,:) = TM(jj,:)/sum(a(1:Nwin-1) == jj);
    else
        TM(jj,jj) = 1;
    end
end
end
