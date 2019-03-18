function [Accuracy, Sensitivity, Specificity, PPV, NPV, Decision, AUC,...
          w_M_Brain_3D, label_ForPerformance,sorted_fileName] =...
    SVM_LC_Kfold_PCA(K)
%% �˴�����heart���ݼ��ϲ��Գɹ�
%input��K=K-fold cross validation,K<N
%output����������Լ�K-fold��ƽ������Ȩ��; label_ForPerformance=�����������label����������ROC����
% path=pwd;
% addpath(path);
% psqiP=Scale_Patient.data(:,2);
% psqiC=Scale_Control.data(:,2);
% allPSQI=[psqiP;psqiC];
%%
% if nargin<2
%     p='D:\WorkStation_2018\WorkStation_2018-05_MVPA_insomnia_FCS\Degree\Results_Degree\Two-sample_t_test\ROISignals\����\Scale_Patient.mat';
%     c='D:\WorkStation_2018\WorkStation_2018-05_MVPA_insomnia_FCS\Degree\Results_Degree\Two-sample_t_test\ROISignals\����\Scale_Control.mat';
%     load(p);
%     load(c);
%     allPSQI=[Scale_Patient.data(:,3);Scale_Control.data(:,2)];
% end
if nargin<1
    mask_path='G:\Softer_DataProcessing\spm12\spm12\tpm\Reslice3_TPM_greaterThan0.2.nii';
    K=5;
%     save_path=pwd;
    save_path='J:\Data_Code\��ޱ��';
end
%% ��ͼ��תΪdata,������label
[fileName_P,path,data_patients ] = lc_Img2Data;
[fileName_C,~,data_controls ] = lc_Img2Data;
data=cat(4,data_patients,data_controls);%data
[dim1,dim2,dim3,n_patients]=size(data_patients);
[~,~,~,n_controls]=size(data_controls);
label=[ones(n_patients,1);zeros(n_controls,1)];%label
%% inmask
[mask_3d,header]=y_Read(mask_path);
mask_3d=mask_3d~=0;
mask=reshape(mask_3d,[],1);
N=n_patients+n_controls;
data=reshape(data,[dim1*dim2*dim3,N]);%�з���Ϊ��������ÿһ��Ϊһ��������ÿһ��Ϊһ������
% implicitmask = sum(data~=0,2)>=size(data,2)-10;%�ڲ�mask,�����ۼ�
% data_inmask=data(implicitmask,:);%�ڲ�mask�ڵ�data
data_inmask=data(mask,:);
data_inmask=data_inmask';
data_inmask_p=data_inmask(label==1,:);
data_inmask_c=data_inmask(label==0,:);
% regress out psqi
% fprintf('\n Regressing out covariate...\n');
% sortedDataInmask=[data_inmask_p;data_inmask_c];
% regressOutedSortedDataInmask=regressOutCovariance(sortedDataInmask,allPSQI);
% data_inmask_p=regressOutedSortedDataInmask(1:size(data_inmask_p,1),:);
% data_inmask_c=regressOutedSortedDataInmask(size(data_inmask_p,1)+1:end,:);
% fprintf('\n Regressing out covariate Finished!\n');
%
%% Ԥ����ռ�
Accuracy=zeros(K,1);
Sensitivity =zeros(K,1);
Specificity=zeros(K,1);
AUC=zeros(K,1);
Decision=cell(K,1);
PPV=zeros(K,1); 
NPV=zeros(K,1);
w_Brain=zeros(K,sum(mask));
label_ForPerformance=cell(1,K);
w_M_Brain=zeros(1,dim1*dim2*dim3);
Predict=NaN(N,1);
sorted_fileName={};
%%  K fold loop
% ���߳�Ԥ��
% if nargin < 2
%   parworkers=0;%default
% end
% data_inmask1=data_inmask;
% data_inmask2=data_inmask;
% label1=label;
% label2=label;
% ���߳�׼�����
% h = waitbar(0,'...');
% �˴�����������ӵ����
indices = crossvalind('Kfold', N, K);
indices_p = crossvalind('Kfold', n_patients, K);
indices_c = crossvalind('Kfold', n_controls, K);
switch K<N
    case 1
        % initialize progress indicator
        %         parfor_progress(K);
        for i=1:K
%             waitbar(i/K,h,sprintf('%2.0f%%', i/K*100)) ;
            
            %% �����ݷֳ�ѵ�������Ͳ����������ֱ�ӻ��ߺͶ������г�ȡ��Ŀ����Ϊ������ƽ�⣩
            % patients data
            Test_index_p = (indices_p == i); 
            sorted_fileName_P=fileName_P(indices_p == i);
            Train_index_p = ~Test_index_p;
            Test_data_p =data_inmask_p(Test_index_p,:);
            Train_data_p =data_inmask_p(Train_index_p,:);
            % controls data
            Test_index_c = (indices_c == i); 
            sorted_fileName_C=fileName_C(indices_c == i);
            Train_index_c = ~Test_index_c;
            Test_data_c =data_inmask_c(Test_index_c,:);
            Train_data_c =data_inmask_c(Train_index_c,:);
            % all data
            trainingData=[Train_data_p;Train_data_c];
            testData=[Test_data_p;Test_data_c];
            sorted_fileName=[sorted_fileName;sorted_fileName_P;sorted_fileName_C];
            % all label
            test_label = [ones(sum(indices_p==i),1);zeros(sum(indices_c==i),1)];
            train_label =  [ones(sum(indices_p~=i),1);zeros(sum(indices_c~=i),1)];
            label_ForPerformance{1,i}=test_label;
            %% ��ά����һ��
             %  ���з����׼������һ������normalization
            [trainingData,testData]=lc_standardization(trainingData,testData,'normalization');
            %   ���ɷֽ�ά
            [COEFF, trainingData,~,~,explained] = pca(trainingData);%�ֱ��ѵ�����������������������ɷֽ�ά��
            testData = testData*COEFF;
%              trainingData= trainingData(:,1:10);
%              testData=testData(:,1:10);
            %% ѵ��ģ��
            model= fitcsvm(trainingData,train_label,'KernelFunction','linear',...
                            'KernelScale','auto');
%             model= fitclinear(trainingData,train_label);
            %%
            [predict_label, dec_values] = predict(model,testData);
            Decision{i}=dec_values(:,2);
            %% ����ģ��
            [accuracy,sensitivity,specificity,ppv,npv]=Calculate_Performances(predict_label,test_label);
            Accuracy(i) =accuracy;
            Sensitivity(i) =sensitivity;
            Specificity(i) =specificity;
            PPV(i)=ppv;
            NPV(i)=npv;
            [AUC(i)]=AUC_LC(test_label,dec_values(:,2));
            %%  �ռ��б�ģʽ
            w_Brain_Component = model.Beta;
            w_Brain(i,:) = w_Brain_Component' * COEFF';

        fprintf('%d/%d\n',i,K)
        end
    case 0 %equal to leave one out cross validation, LOOCV
        for i=1:K
            waitbar(i/K,h,sprintf('%2.0f%%', i/K*100)) ;
            %K fold
            test_index = (indices == i); train_index = ~test_index;
            trainingData =data_inmask(train_index,:);
            train_label = label(train_index,:);
            testData = data_inmask(test_index,:);
            test_label = label(test_index);
            label_ForPerformance{1,i}=test_label;
            %% ��ά����һ��
            %���ɷֽ�ά
            [COEFF, trainingData] = pca(trainingData);%�ֱ��ѵ�����������������������ɷֽ�ά��
            testData = testData*COEFF;
            %���з����һ��
            % [train_data,test_data,~] = ...
            %    scaleForSVM(train_data,test_data,0,1);%һ���з����һ�����˴������飬����ʵ�ʽǶ���˵���ǿ��Եġ�
            [trainingData,PS] = mapminmax(trainingData');
            trainingData=trainingData';
            testData = mapminmax('apply',testData',PS);
            testData =testData';
            %% ѵ��ģ��
            model= fitclinear(trainingData,train_label);
            %%
            [predict_label, dec_values] = predict(model,testData);
            Decision{i}=dec_values(:,2);
            Predict(i,1)=predict_label;
            %%  �ռ��б�ģʽ
            w_Brain_Component = model.Beta;
            w_Brain(i,:) = w_Brain_Component' * COEFF';
            %             if ~randi([0 4])
            %                 parfor_progress;%������
            %             end
        end
end
%% ƽ���Ŀռ��б�ģʽ
W_mean=mean(w_Brain);%ȡ����LOOVC��w_brain��ƽ��ֵ
w_M_Brain(mask)=W_mean;
w_M_Brain_3D=reshape(w_M_Brain,dim1,dim2,dim3);
%% �����������
Accuracy(isnan(Accuracy))=0; Sensitivity(isnan(Sensitivity))=0; Specificity(isnan(Specificity))=0;
PPV(isnan(PPV))=0; NPV(isnan(NPV))=0; AUC(isnan(AUC))=0;
%% ��ʾģ������ K < N
if K<N
    performances=[mean([Accuracy,Sensitivity, Specificity, PPV, NPV,AUC]);...
        std([Accuracy,Sensitivity, Specificity, PPV, NPV,AUC],1)];%��ʾ�������,std�ķ�ĸ�ǡ�N��
    performances=performances';
    f = figure;
    title(['Performance with',' ',num2str(K),'-fold']);
    axis off
    t = uitable(f);
    d = performances;
    t.Data = d;
    t.ColumnName = {'mean performance','std'};
    t.RowName={'MAccuracy','MSensitivity','MSpecificity','MPPV','MNPV','MAUC'};
    t.Position = [50 0 400 300];
end
% close (h)
%% ��ʾģ������ K==N���ȼ���LOOCV
if K==N
    [Accuracy, Sensitivity, Specificity, PPV, NPV]=Calculate_Performances(Predict,cell2mat(label_ForPerformance));
    AUC=AUC_LC(label_ForPerformance,cell2mat(Decision));
    performances=[Accuracy, Sensitivity, Specificity, PPV, NPV,AUC]';%��ʾ�������
    f = figure;
    title(['Performance with',' ',num2str(K),'-fold']);
    axis off
    t = uitable(f);
    d = performances;
    t.Data = d;
    t.ColumnName = {'performance'};
    t.RowName={'Accuracy','Sensitivity','Specificity','PPV','NPV','AUC'};
    %             t.ColumnEditable = true;
    t.Position = [50 0 300 300];
end
%% �������Ȩ��ͼ��������
% gray matter mask
% [file_name,path_source1,~]= uigetfile( ...
%     {'*.img;*.nii;','All Image Files';...
%     '*.*','All Files' },...
%     '��ѡ��mask����ѡ��', ...
%     'MultiSelect', 'off');
% img_strut_temp=load_nii([path_source1,char(file_name)]);
% mask_graymatter=img_strut_temp.img~=0;
w_M_Brain_3D(~mask_3d)=0;
% save nii
data=datestr(now,30);
y_Write(w_M_Brain_3D,header,['w_M_Brain_3D_',data,'.nii']);
%save results
save([save_path filesep 'Results_MVPA_',data,'.mat'],...
    'Accuracy', 'Sensitivity', 'Specificity',...
    'PPV', 'NPV', 'Decision', 'AUC', 'w_M_Brain_3D', 'label_ForPerformance','sorted_fileName');
print(gcf,'-dtiff','-r600',[fullfile(save_path,'Mean Performances'),data])
end


