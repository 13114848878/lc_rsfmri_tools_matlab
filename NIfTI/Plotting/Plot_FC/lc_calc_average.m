function average_edge = lc_calc_average(in_path,if_save,out_name)
% ��;������һ�鱻������ߵ�ƽ��ֵ
% input:
%   in_path:һ�鱻�Ե��ļ���
%   if_save���Ƿ񱣴���
%   out_name�������������֣���·����
% output:
%    average_edge: һ�鱻��ƽ����������
%%
% ��ȡ�����ļ���·��
% path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\state\allState17_4\state1\state1_HC';
subj=dir(fullfile(in_path,'*.mat'));
subj_name={subj.name}';
subj_path=fullfile(in_path,subj_name);

%���ز�ͬʱ�������б��Աߵĺͣ���Լ����ռ䣩
n_subj=length(subj_name);
for i=1:n_subj
    subj_edge=importdata(subj_path{i});
    % inf---1,nan---0
    subj_edge(isinf(subj_edge))=1;
    subj_edge(isnan(subj_edge))=0;
    % ���һ������ȫ��Ϊinf����nan������������Ϊ����������
    if sum(subj_edge(:))==1 || sum(subj_edge(:))==0
        fprintf('����:%s�����ݿ��ܴ����쳣������\n',subj_path{i});
    end
    % ��ʼ��sum_edge
    if i==1
        sum_edge=subj_edge;
    else
        sum_edge=sum_edge+subj_edge;
    end
end

% �������������õ���ֵ
average_edge=sum_edge/n_subj;

% inf---1,nan---0
% average_edge(isinf(average_edge))=1;
% average_edge(isnan(average_edge))=0;

% save
if if_save
    save(out_name,'average_edge');
end

disp('Done!')
end

