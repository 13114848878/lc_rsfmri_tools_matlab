% ����ȫ�Եı�����(�źŵķ���)
% �˴���ı��Ժ���ǿʦ�ֵĴ��루Variance_han��
%% ==============================================================
% input
FourDDataPath=('H:\FunImgARWDFCB'); % 4D ����Ŀ¼:[../subjxxx/*.nii]*nSubj
keyword='*nii'; % ��һ�������ļ������м���fileʱ��ѡ�������ʽ(ֻ��ѡ���һ��).
maskPath='H:\dynamicALFF\Results\DALFF\50_0.9\Statistical_Results\GrayMask_Reslice3_greaterThan0.2.nii';
threshold=0.2;
outPath=('H:\Var');
%% ==============================================================
% load mask
mask=load_nii(maskPath);
mask=mask.img>threshold;
% fetch all path of all subject 4D data file
allFolderName=dir(FourDDataPath);
allFolderName=allFolderName(3:end);
allFolderName={allFolderName.name}';
%
 if iscell(allFolderName)
    nSubj=length(allFolderName);
 else
     warning('������������?');
 end
%% ==============================================================
parpool(6);
parfor i=1:nSubj
    fprintf('%d/%d\n',i,nSubj);
    oneFolderName=fullfile(FourDDataPath,allFolderName{i});
    oneFolderName=dir(fullfile(oneFolderName,keyword));
    oneFolderName=oneFolderName.name; % �ж��ʱ��ֻѡ���һ��
    [oneFourDData,header] =y_Read(fullfile(FourDDataPath,allFolderName{i},oneFolderName));
%     oneFourDData(~mask,:)=0;
    BOLDVar=var(oneFourDData,0,4);
    BOLDVar(~mask)=0; % apply mask
    % ȥ��ֵ����ֵ��3����׼�
    myMean=mean(BOLDVar(:));
    myStd=std(BOLDVar(:));
    BOLDVar(BOLDVar>myMean+3*myStd|BOLDVar<myMean-3*myStd)=0;
    % save to nii
    saveSubFolder=fullfile(outPath,allFolderName{i});
    mkdir(saveSubFolder);
    y_Write(BOLDVar,header,fullfile(saveSubFolder,['BOLDVar_',allFolderName{i},'.nii']));
end
    