function [R,error2,m]=test(Close,AskPrice1,BidPrice1,lambda)
[theta, y_test, X_test,error2,AskPrice1,BidPrice1] = linearRegression(Close,AskPrice1,BidPrice1,lambda);

IFdata = y_test;

%% ���׹��̷���
%��λPos=1��ͷ1�֣�Pos=0�ղ֣�Pos=-1��ͷ1��
Pos = zeros(length(IFdata),1);
%��ʼ�ʽ�
InitialE = 50e4;
%�������¼
ReturnD = zeros(length(IFdata),1);
%��ָ����
scale = 300;

MA20 = X_test*theta;
MA5 = y_test;

LongLen=5;
for t = LongLen:length(IFdata)
    %�����źţ�5�վ����ϴ�20�վ���
    SignalBuy = MA5(t)>MA5(t-1) && MA5(t)>MA20(t) && MA5(t-1)>=MA20(t-1) && MA5(t-2)<=MA20(t-2);
    %�����źţ�5�վ�������20�վ���
    SignalSell = MA5(t)<MA5(t-1) && MA5(t)<MA20(t) && MA5(t-1)<=MA20(t-1) && MA5(t-2)>=MA20(t-2);
    %��������
    if SignalBuy==1
        %�ղֿ���ͷ1��
        if Pos(t-1)==0
            Pos(t)=1;
            ReturnD(t)=(IFdata(t)-AskPrice1(t)-0.00007*IFdata(t))*scale;
            %text(t,IFdata(t),'\leftarrow����1��','FontSize',8);
            %plot(t,IFdata(t),'ro','markersize',8);
            continue
        end
        %ƽ��ͷ����ͷ1��
        if Pos(t-1)==-1
            Pos(t)=1;
            ReturnD(t)=(IFdata(t-1)-AskPrice1(t)-IFdata(t)*0.00007)+...
                (IFdata(t)-AskPrice1(t)-0.00007*IFdata(t))*scale;
            %text(t,IFdata(t),'\leftarrowƽ�տ���1��','FontSize',8);
            %plot(t,IFdata(t),'ro','markersize',8);
            continue
        end
    end
    
    %��������
    if SignalSell==1
        %�ղֿ���ͷ1��
        if Pos(t-1)==0
            Pos(t)=-1;
            ReturnD(t)=(BidPrice1(t)-IFdata(t)-0.00007*IFdata(t))*scale;
            %text(t,IFdata(t),'\leftarrow����1��','FontSize',8);
           % plot(t,IFdata(t),'rd','markersize',8);
            continue;
        end
        %ƽ��ͷ����ͷ1��
        if Pos(t-1)==1
            Pos(t)=-1;
            ReturnD(t)=(IFdata(t)*0.99993-IFdata(t-1))*scale+...
                (BidPrice1(t)-IFdata(t)-0.00007*IFdata(t))*scale;
            %text(t,IFdata(t),'\leftarrowƽ�࿪��1��','FontSize',8);
            %plot(t,IFdata(t),'rd','markersize',8);
            continue;
        end
    end
    
    %ÿ��ӯ������
    if Pos(t-1)==1
        Pos(t)=1;
        ReturnD(t)=(IFdata(t)-IFdata(t-1))*scale;
    end
    if Pos(t-1)==-1
        Pos(t)=-1;
        ReturnD(t)=(IFdata(t-1)-IFdata(t))*scale;
    end
    if Pos(t-1)==0
        Pos(t)=0;
        ReturnD(t)=0;
    end
    
    %���һ��������������гֲ֣�����ƽ��
    if t==length(IFdata) && Pos(t-1)~=0
        if Pos(t-1)==1
            Pos(t)=0;
            ReturnD(t)=(IFdata(t)-IFdata(t-1))*scale;
            %text(t,IFdata(t),'\leftarrowƽ��1��','FontSize',8);
            %plot(t,IFdata(t),'rd','markersize',8);
        end
        if Pos(t-1)==-1
            Pos(t)=0;
            ReturnD(t)=(IFdata(t-1)-IFdata(t))*scale;
            %text(t,IFdata(t),'\leftarrowƽ��1��','FontSize',8);
            %plot(t,IFdata(t),'ro','markersize',8);
        end
    end    
end

%% �ۼ�����
ReturnCum=cumsum(ReturnD);
ReturnCum=ReturnCum+InitialE;
R=ReturnCum(end);
%% �������س�
MaxDrawD=zeros(length(IFdata),1);
for t=LongLen:length(IFdata)
    C=max(ReturnCum(1:t));
    if C==ReturnCum(1:t)
        MaxDrawD(t)=0;
    else
        MaxDrawD(t)=(ReturnCum(t)-C)/C;
    end
end
MaxDrawD=abs(MaxDrawD);
m=max(MaxDrawD);
%% �����껯���� ���س� ����Ƶ�� ������ձ� ���ձ���
Return=(ReturnCum(end)-InitialE)/InitialE;
AnReturn=((Return+1).^(length(Close)/length(y_test)))-1;
fprintf('�껯����Ϊ %3.2d\n',AnReturn);
maxdraw=max(MaxDrawD);
fprintf('��ʷ���س�Ϊ %3.2d\n',maxdraw);
Dfrq=sum(diff(Pos)~=0)/(length(y_test)/273);
fprintf('�ս���Ƶ��Ϊ %3.2d\n',Dfrq);
RBRatio=AnReturn/max(MaxDrawD);
fprintf('���������Ϊ %3.2d\n',RBRatio);
r=diff(ReturnCum)./ReturnCum(2:end);
shp=sqrt(length(r))*mean(r)/std(r);
% Tucker Balch(Georgia Institute of Technology) Computational investing
% https://www.coursera.org/course/compinvesting1
fprintf('���ձ���Ϊ %3.2d\n',shp);
fprintf('����Ϊ %3.2d\n',R);
fprintf('���Ϊ %3.2d\n',error2);

% %% ͼ��չʾ
% figure
% subplot(3,1,1);
% plot(ReturnCum);
% grid on;
% axis tight;
% title('��������');
% subplot(3,1,2);
% plot(Pos,'LineWidth',1.8);
% grid on;
% axis tight;
% title('��λ');
% 
% subplot(3,1,3);
% plot(MaxDrawD);
% grid on;
% axis tight;
% title(['���س�����ʼ�ʽ�','num2str(InitialE/1e4),']);
% 
% figure
% plot([y_test,X_test*theta]);
% grid on;
% legend('y-test','y-predict');
% title('���ײ��Բ��Թ���')
% hold on
% plot(find(Pos==-1),y_test(find(Pos==-1)),'g.')
% plot(find(Pos==1),y_test(find(Pos==1)),'r.')
% hold off

 



