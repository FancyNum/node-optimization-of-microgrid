function line=nodeoptimization(LN,n,slackbus)
%LN is parameters of branch;n is the number of bus;slackbus is slack bus;
%mn is the bus which has the least branch;code is serial number before
%optimization;line is serial number after optimization;num is number of
%branches of each bus.
deletematrix=zeros(n);
code=1:n;
num=zeros(1,n);
for i=1:length(LN(:,1))    %生成支路关联矩阵deletematrix      矩阵num记录每个节点的度
    deletematrix(LN(i,1),LN(i,2))=1;
    num(LN(i,1))=num(LN(i,1))+1;
    deletematrix(LN(i,2),LN(i,1))=1;
    num(LN(i,2))=num(LN(i,2))+1;
end
line=zeros(1,n);
for i=1:n-1      %节点优化编号：半动态优化法。                       %半动态优化法：找到连接支路最少的节点进行编号,然后消去该节点,每消去
    [~,mn]=min(num);  %mn为节点度最小的节点编号                                 %一个节点 ,尚未编号节点的支路连接数就会发生变化,然后 
    for j=1:length(num)                                                          %从未编号节点中查找连接支路最少的节点进行编号
        if deletematrix(mn,j)~=0
            if j<length(num)
                l=j;       %将与mn相邻节点的编号赋值给l，并将此相邻节点的度数减1
                num(j)=num(j)-1;
                for k=(j+1):length(num)   %继续向下搜索,将与mn相邻的节点k赋值给m
                    if deletematrix(mn,k)~=0
                        m=k;
                        if deletematrix(l,m)==0   %如果与mn相邻的两个节点l和m不相邻，则将支路关联矩阵相应位置置1，并更新节点度矩阵
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