function dynamic_std=lc_calc_metrics_for_dynamic_FC(path,suffix,save_path)
% ���㶯̬�������ӵ���Ӧmetrics(std)
% input:
%   path:ĳһ�鱻�������ļ���
%   suffix����ѡ���ļ���׺
%   n_node����������Ľڵ���Ŀ
%   save_path:��������ļ���
% output:
%   dynamic_std:���б��Ե�metrics(���浽��Ӧ�ļ�����)
%%
% input
if nargin<1
    path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\DynamicFC_length18_step1_screened\MDD';
    suffix='*.mat';
    save_path='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zDynamic\DynamicFC_length18_step1_screened\MDD_std';
end

if ~exist(save_path,'dir')
    mkdir(save_path);
end
%
subj=dir(fullfile(path,suffix));
subj={subj.name}';
subj_path=fullfile(path,subj);

n_subj=length(subj);
for i =1:n_subj
    fprintf('%d/%d\n',i,n_subj);
    dynamic_fc=importdata(subj_path{i});
    dynamic_std=var(dynamic_fc,0,3);
    % save
    target=fullfile(save_path,subj{i});
    save(target,'dynamic_std');
end
fprintf('Done!\n');
end