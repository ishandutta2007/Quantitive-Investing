function [X,error1]=yalin(files)
A=xlsread(files);
B=A(:,1);%Open
C=A(:,2);%High
D=A(:,3);%Low
E=A(:,4);%Close
F=A(:,5);%Volume
G=A(:,6);%�ڶ���ļ۸�

P=[B,C,D,E,F]';
T=[G]';

% net=newff([0.1;0.1;0.1],[5,1],{'tansig','logsig'},'traingd');
net=newff(P,T,[4,1],{'tansig','logsig'},'traingd');
net.trainParam.epochs=15000;
net.trainParam.goal=0.01;
LP.lr=0.1;
net=train(net,P,T);

y=sim(net,P);
plot(y,'b');
%plot(y,'d','MarkerFaceColor','r','MarkerSize',8);
hold on
plot(T,'r')
%plot(T,'s','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',8);

title('һȺ**��');
legend('ʵ�ʵ�','Ԥ���');
net.divideFcn = ''

X=[y,T];
error1=mean(abs(y-T)./y);
