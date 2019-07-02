function line=nodeoptimization(LN,n,slackbus)
%LN is parameters of branch;n is the number of bus;slackbus is slack bus;
%mn is the bus which has the least branch;code is serial number before
%optimization;line is serial number after optimization;num is number of
%branches of each bus.
deletematrix=zeros(n);
code=1:n;
num=zeros(1,n);
for i=1:length(LN(:,1))    %����֧·��������deletematrix      ����num��¼ÿ���ڵ�Ķ�
    deletematrix(LN(i,1),LN(i,2))=1;
    num(LN(i,1))=num(LN(i,1))+1;
    deletematrix(LN(i,2),LN(i,1))=1;
    num(LN(i,2))=num(LN(i,2))+1;
end
line=zeros(1,n);
for i=1:n-1      %�ڵ��Ż���ţ��붯̬�Ż�����                       %�붯̬�Ż������ҵ�����֧·���ٵĽڵ���б��,Ȼ����ȥ�ýڵ�,ÿ��ȥ
    [~,mn]=min(num);  %mnΪ�ڵ����С�Ľڵ���                                 %һ���ڵ� ,��δ��Žڵ��֧·�������ͻᷢ���仯,Ȼ�� 
    for j=1:length(num)                                                          %��δ��Žڵ��в�������֧·���ٵĽڵ���б��
        if deletematrix(mn,j)~=0
            if j<length(num)
                l=j;       %����mn���ڽڵ�ı�Ÿ�ֵ��l�����������ڽڵ�Ķ�����1
                num(j)=num(j)-1;
                for k=(j+1):length(num)   %������������,����mn���ڵĽڵ�k��ֵ��m
                    if deletematrix(mn,k)~=0
                        m=k;
                        if deletematrix(l,m)==0   %�����mn���ڵ������ڵ�l��m�����ڣ���֧·����������Ӧλ����1�������½ڵ�Ⱦ���
                            deletematrix(l,m)=1;
                            num(l)=num(l)+1;
                            deletematrix(m,l)=1;
                            num(m)=num(m)+1;
                        end
                    end
                end
            else
                num(j)=num(j)-1;
            end
        end
    end
    line(i)=code(mn);
    num(mn)=[];
    code(mn)=[];
    deletematrix(mn,:)=[];
    deletematrix(:,mn)=[];
end
line(n)=code(1);
line=[line,slackbus];
for i=1:n
    if line(i)==slackbus
        line(i)=[];
        break;
    end
end