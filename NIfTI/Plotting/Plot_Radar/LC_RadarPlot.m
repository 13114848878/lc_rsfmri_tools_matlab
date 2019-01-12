function  LC_RadarPlot(X,opt)
% input:
%     X: 1D array
%%
% LC_RadarPlot([.82,0.79,0.84,0.85])
if nargin <2 && ~exist('opt','var')
    fprintf('no opt')
    opt.linewidth=2;
    opt.linestyle='-';
    opt.color='b';
    opt.TickLabel={''};
else
    if ~isfield(opt,'linewidth')
        opt.linewidth=2;
    end
    if ~isfield(opt,'linestyle')
        opt.linestyle='-';
    end
    if ~isfield(opt,'color')
        opt.color='b';
    end
    if ~isfield(opt,'TickLabel')
        opt.TickLabel={''};
    end
end
%% =========================����׼��===============================
X=reshape(X,[],1);
% theta=linspace(0,360,numel(X));
X=[X;X(1)];
theta=linspace(0,360,numel(X));
NumOfTickLabel = deg2rad(theta);
%% =========================TickLabel===============================
TickLabel=opt.TickLabel;
%% =========================���״�ͼ===============================
polarplot(NumOfTickLabel,X,...
    'linewidth',opt.linewidth,'linestyle',opt.linestyle,'color',opt.color);
% polarplot(NumOfTickLabel,X,...
%     'linewidth',opt.linewidth,'linestyle',opt.linestyle);
%% ==================����ͼƬ��ʾ��ʽ==============================
ax=gca;

% ����
ax.Color ='w';%�״�ͼ��������ɫ��

% ���귶Χ
ax.ThetaLim = [0 360];%������ķ�Χ��

% ����
ax.FontSize =10;%�����С
ax.ThetaColor = 'k';%�ı������ַ���ɫ

% ����
ax.ThetaGrid = 'on';%�����ֱ��������ʾ���
ax.RGrid = 'on';%���ε�������ʾ���
ax.LineWidth = 1.5;%�״�ͼ���Ĵ�ϸ��
ax.GridLineStyle = '-';%�������ʾ��ʽ��
ax.GridColor ='k';%�������ɫ��
% ax.RTick=linspace(0,max(X),5);%�����߿̶�
% ax.RTick=[0,0.2,0.3,0.4,0.9];%�����߿̶�
% TickLabel
ax.ThetaTickLabel = TickLabel;%�ı�������ַ�
ax.ThetaTick = theta;% ��ʾ�������
ax.ThetaZeroLocation = 'top';% 0������λ��

% R
ax.RAxisLocation = 0;% R���λ��
% ax.RTickLabel = {'a','b','c','d','e'};%R�������
ax.RTickLabelRotation =0;% R�������ַ���ת
ax.RColor = 'k' ;% �ı�R�������ַ�����ɫ
% legend({'AUC'},'Location',[0.8 0.7 0.15 0.15],'FontSize',10);
% set(hl,'Orientation','horizon');
% title('��ͬ�������㷨�ķ������ܱȽ�','Color','k','FontSize',15,'FontWeight','bold');
% print('a.tif','-dtiff','-r300bpi')
end

