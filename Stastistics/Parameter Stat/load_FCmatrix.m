function all_subj_fc=load_FCmatrix(path,suffix,n_row,n_col)
% ????path???��??��?????FC
subj=dir(fullfile(path,suffix));
subj={subj.name}';
subj_path=fullfile(path,subj);
 
n_subj=length(subj);
all_subj_fc=zeros(n_subj,n_row,n_col);
for i =1:n_subj
    all_subj_fc(i,:,:)=importdata(subj_path{i});
end
end
