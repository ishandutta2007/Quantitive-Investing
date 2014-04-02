load('data_minute_2011.mat');

load('Theta.mat');

[theta, y_test, X_test, minute_bidPrince, minute_askPrince, train_error] = linearRegression(0.1);

IFdata = y_test;%793*1

MA20 = [];
Theta = reshape(Theta,[4,49]);
for i = 1:size(Close,1)/1000
    MA20 = [MA20; X_test(i:i+999,:)*Theta(:,i)];
end

MA5 = y_test;

test_error = sumabs((MA20-MA5))/size(MA5,1);

LongLen = 5;

for t = LongLen:length(IFdata)
    if(mod(t,100)==0)
        fprintf('t = %d\n',t);
    end
    %�����źţ�5�վ����ϴ�20�վ���
    SignalBuy = MA5(t)>MA5(t-1) && MA5(t)>MA20(t) && MA5(t-1)>MA20(t-1) && MA5(t-2)<=MA20(t-2);
    %�����źţ�5�վ�������20�վ���
    SignalSell = MA5(t)<MA5(t-1) && MA5(t)<MA20(t) && MA5(t-1)<MA20(t-1) && MA5(t-2)>=MA20(t-2);
    %��������
    if SignalBuy==1
        %�ղֿ���ͷ1��
        if Pos(t-1)==0
            Pos(t)=1;
            ReturnD(t)=(-0.00007*minute_askPrince(t))*scale;
%             text(t,IFdata(t),'\leftarrow����1��','FontSize',12);
%             plot(t,IFdata(t),'ro','markersize',8);
            continue
        end
        %ƽ��ͷ����ͷ1��
        if Pos(t-1)==-1
            Pos(t)=1;
            ReturnD(t)=(-0.00014*minute_askPrince(t))*scale;
%             ReturnD(t)=(IFdata(t-1)-IFdata(t))*scale;
%             text(t,IFdata(t),'\leftarrowƽ�տ���1��','FontSize',12);
%             plot(t,IFdata(t),'ro','markersize',8);
            continue
        end
    end
    
    %��������
    if SignalSell==1
        %�ղֿ���ͷ1��
        if Pos(t-1)==0
            Pos(t)=-1;
            ReturnD(t)=(-0.00007*minute_bidPrince(t))*scale;
%             text(t,IFdata(t),'\leftarrow����1��','FontSize',12);
%             plot(t,IFdata(t),'rd','markersize',8);
            continue;
        end
        %ƽ��ͷ����ͷ1��
        if Pos(t-1)==1
            Pos(t)=-1;
            ReturnD(t)=(-0.00014*minute_bidPrince(t))*scale;
%             Return(t)=(IFdata(t)-IFdata(t-1))*scale;
%             text(t,IFdata(t),'\leftarrowƽ�࿪��1��','FontSize',12);
%             plot(t,IFdata(t),'rd','markersize',8);
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
%             text(t,IFdata(t),'\leftarrowƽ��1��','FontSize',12);
%             plot(t,IFdata(t),'rd','markersize',8);
        end
        if Pos(t-1)==-1
            Pos(t)=0;
            ReturnD(t)=(IFdata(t-1)-IFdata(t))*scale;
%             text(t,IFdata(t),'\leftarrowƽ��1��','FontSize',12);
%             plot(t,IFdata(t),'ro','markersize',8);
        end
    end    
end

%% �ۼ�����
ReturnCum=cumsum(ReturnD);
ReturnCum=ReturnCum+InitialE;

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
fprintf('���ձ���Ϊ %3.2d\n',shp);
fprintf('����Ϊ %3.2d\n',R);
fprintf('���Ϊ %3.2d\n',error2);