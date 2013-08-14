function ex1(symbol)
%% Notes
% ���ǰ����еļ����������������ʵ�ֲ���Ѱ�ź�Ĳ��Թ���
% 1.������para_search�ҵ���õ�sRate,bRate
% 2.�ٽ�����������ݵ���������Եõ���sRate,bRate�����ף��������Ѱ�ŵĽ�����Ա�

%% Data Import
fprintf('Data Import...\n\n')
getData('000002.sz','1/1/2011','1/1/2012')

%% Searching the best Parameter during 1/1/2011 and 1/1/2012
fprintf('Searching the best Parameters during 1/1/2011 to 1/1/2012...\n')
[best_buy1,best_sell1]=para_search2(symbol);

%% Compare
fprintf('Compare with the different Parameters during 1/1/2012 to 8/1/2013. \n\n')
getData(symbol,'1/1/2012','8/1/2013')
% Parameters 1
figure(1)
Capital=best_test(symbol,100000,best_buy1,best_sell1,1,0.3,0.1,0.09);
fprintf('The final capital with parameter #1 is: %2.2f\n',Capital)
% Parameters 2
[best_buy2,best_sell2]=para_search2(symbol);
figure(2)
Capital2=best_test(symbol,100000,best_buy2,best_sell2,1,0.3,0.1,0.09);
fprintf('The final capital with parameter #2 is: %2.2f \n',Capital2)