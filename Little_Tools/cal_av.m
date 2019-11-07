function cal_av()
% This function is used to calculate average matrix of a group of matrices
[file_name, file_path] = uigetfile('*.mat');
out_path = uigetdir(pwd,'select saving folder');
%% ----------------------------------------------------------------
% load
file = fullfile(file_path, file_name);
data = importdata(file);
name = fieldnames(data);

% cal
n_subj = length(name);
sum_edge = 0;  % ��ʼ��sum_edge
for i=1:n_subj
    subj_edge = getfield(data,name{i});
    % inf---1,nan---0
    subj_edge(isinf(subj_edge))=1;
    subj_edge(isnan(subj_edge))=0;
    % ���һ������ȫ��Ϊinf����nan������������Ϊ����������
    if sum(subj_edge(:))==numel(subj_edge) || sum(subj_edge(:))==0
        fprintf('����:%s�����ݿ��ܴ����쳣������\n',name{i});
    end
    sum_edge = sum_edge+subj_edge;
end

average_edge=sum_edge/n_subj;
save(fullfile(out_path,'average_edge.mat'),'average_edge');

% show
imagesc(average_edge)
axis off
colorbar

% save
print('-dtiff','-r600',fullfile(out_path, 'average_edge.tiff'));
disp('Done!')
end