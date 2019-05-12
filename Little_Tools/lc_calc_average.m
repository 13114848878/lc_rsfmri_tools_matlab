function average_edge = lc_calc_average(in_path, is_save, suffix, out_name)
% ��;������һ�鱻������ߵ�ƽ��ֵ
% input:
%   in_path:һ�鱻�Ե��ļ���
%   if_save���Ƿ񱣴���
%   out_name�������������֣���·����
% output:
%    average_edge: һ�鱻��ƽ����������
%% input
if nargin < 4
    out_name = 'average_edge';
end

if nargin < 3
    suffix = '*.mat';
end

if nargin < 2
    is_save = 1;
end

if nargin < 1
    in_path = uigetdir(pwd, 'select folder that containing group mat files');
end

%% read all files' directory
subj = dir(fullfile(in_path,suffix));
subj_name = {subj.name}';
subj_dir = fullfile(in_path,subj_name);

%���ز�ͬʱ�������б��Աߵĺͣ���Լ����ռ䣩
n_subj = length(subj_name);
sum_edge = 0;  % ��ʼ��sum_edge
for i=1:n_subj
    subj_edge = importdata(subj_dir{i});
	subj_edge = load(subj_dir{i});
    % inf---1,nan---0
    subj_edge(isinf(subj_edge))=1;
    subj_edge(isnan(subj_edge))=0;
    % ���һ������ȫ��Ϊinf����nan������������Ϊ����������
    if sum(subj_edge(:))==numel(subj_edge) || sum(subj_edge(:))==0
        fprintf('����:%s�����ݿ��ܴ����쳣������\n',subj_dir{i});
    end
    sum_edge = sum_edge+subj_edge;
end

average_edge=sum_edge/n_subj;

% save
if is_save
    save(out_name,'average_edge');
end

disp('Done!')
end

