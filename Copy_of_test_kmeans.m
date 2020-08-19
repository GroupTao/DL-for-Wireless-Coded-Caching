%% k_means++ ���� 
clear
close all
load('Youtube_f50_new.mat', 'view_count')
window=14;
s=size(view_count);
mus_req_add=view_count+0;
kmeans_sample=zeros((s(1)-window)*s(2),window+1);
kmeans_sample_std=zeros((s(1)-window)*s(2),1);
mus_req_nouser_clean=view_count;
clean_window=21;
sum_clean=0;
cluster_number=2;
tt=['k_meanplusC',num2str(cluster_number),'W',num2str(window),'_Youtube_sample_t660_hope.mat'];
%% ��ϴ����
%     for f=1:s(2)
%         for t=1:s(1)-window
%           temp=view_count(t:(t+window),f);
%           temp=temp./view_count(t,f)-1;  
%             iu=find(abs(temp)>3);
%             if ~isempty(iu)
%                 for iud=1:length(iu)
%                     if t+iu(iud)-1>=clean_window
%                    mus_req_nouser_clean(t+iu(iud)-1,f)=(mus_req_nouser_clean((t+iu(iud)-1-1),f)+mus_req_nouser_clean(t+iu(iud),f))/2; 
%                     end
%                 end
%             end 
%         end
%     end
% %% ���������˶��ٸ���
% for f=1:s(2)
%     for t=1:s(1)
%         if mus_req_nouser_clean(t,f)~=view_count(t,f)
%             sum_clean=sum_clean+1;
%         end
%     end
% end

%% ��������
index=1;
    for f=1:s(2)
        for t=1:s(1)-window
          temp=mus_req_nouser_clean(t:(t+window),f);
          kmeans_sample_std(index,1)=max(temp);
          temp=temp./max(temp);  
          kmeans_sample(index,:)=temp;       
          index=index+1;  
        end
    end
%% ����
%�����ȡ150����
%X = [randn(50,2)+ones(50,2);randn(50,2)-ones(50,2);randn(50,2)+[ones(50,1),-ones(50,1)]];
opts = statset('Display','final','UseParallel',true,'MaxIter',1000);
%load('kmeans_test.mat', 'X')
%����Kmeans����
%X N*P�����ݾ���
%Idx N*1������,�洢����ÿ����ľ�����
%Ctrs K*P�ľ���,�洢����K����������λ��
%SumD 1*K�ĺ�����,�洢����������е���������ĵ����֮��
%D N*K�ľ��󣬴洢����ÿ�������������ĵľ���;

%[Idx,Ctrs,SumD,D] = kmeans(X,3,'Start',X(1:3,:),'Replicates',1,'Options',opts);
[Idx,Ctrs,SumD,D] = kmeans(kmeans_sample(:,1:window),cluster_number,'Replicates',20,'Options',opts);
cluster_sample_number=zeros(1,cluster_number);

for i=1:cluster_number
    cluster_sample_number(1,i)=length(find(Idx==i));
    SumD(i,2)=SumD(i,1)/cluster_sample_number(1,i);
    SumD(i,3)=cluster_sample_number(1,i);
end
iid=find(Idx==1);
plot(kmeans_sample(iid(1:6),:)');
save (tt, 'mus_req_nouser_clean', 'cluster_number', 'cluster_sample_number', 'Ctrs', 'D', 'Idx', 'kmeans_sample', 'kmeans_sample_std','SumD', 'window')
%��������Ϊ1�ĵ㡣X(Idx==1,1),Ϊ��һ��������ĵ�һ�����ꣻX(Idx==1,2)Ϊ�ڶ���������ĵڶ�������
% plot(X(Idx==1,1),X(Idx==1,2),'r.','MarkerSize',14)
% hold on
% plot(X(Idx==2,1),X(Idx==2,2),'b.','MarkerSize',14)
% hold on
% plot(X(Idx==3,1),X(Idx==3,2),'g.','MarkerSize',14)
% 
% %����������ĵ�,kx��ʾ��Բ��
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
% 
% legend('Cluster 1','Cluster 2','Cluster 3','Centroids','Location','NW')

