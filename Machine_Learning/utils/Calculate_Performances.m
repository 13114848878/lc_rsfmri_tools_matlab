function [accuracy,sensitivity,specificity,PPV,NPV]=Calculate_Performances(predict_label,real_label)
%����ģ�͵�Ԥ�����
%����;Ԥ���ǩ����ʵ��ǩ
%���������������;PPV������Ԥ���ʣ�NPV������Ԥ����
%% ��������
% ����׼��
% ����1��Ϊ0.
predict_label=predict_label==1;
real_label=real_label==1;
% ���������.
predict_label=reshape(predict_label,length(predict_label),1);
real_label=reshape(real_label,length(real_label),1);
% ����
TP=sum(real_label.*predict_label);
FN=sum(real_label)-sum(real_label.*predict_label);
TN=sum((real_label==0).*(predict_label==0));
FP=sum(real_label==0)-sum((real_label==0).*(predict_label==0));
    accuracy =(TP+TN)/(TP + FN + TN + FP); %����
    sensitivity =TP/(TP + FN);
    specificity =TN/(TN + FP); 
    PPV=TP/(TP+FP);%positive predictive
    NPV=TN/(TN+FN);%negative predictive value
end

