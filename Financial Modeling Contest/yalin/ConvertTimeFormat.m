function IF2011_minute=ConvertTimeFormat(IF2011)
% ����ԭʼ���ݣ�������Ӽ��������
% ת��ʱ���ʽ
time=IF2011(:,3);
for i=1:length(time)
    hour=floor(time(i)*24);
    minute=floor((time(i)*24-hour)*60);
    IF2011(i,3)=hour;
    IF2011(i,4)=minute;
end
% �õ����Ӽ�����
Minute=IF2011(:,4);
IF2011_minute=[];
for i=2:length(Minute)
    if Minute(i-1)~=Minute(i)
        IF2011_minute=[IF2011_minute;IF2011(i-1,:)];
    end;
end
IF2011_minute=[IF2011_minute;IF2011(end,:)];