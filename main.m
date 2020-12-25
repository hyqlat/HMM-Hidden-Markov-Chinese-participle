%fc
%初始化统计
path="data_train2.txt";
[sentence,word_dic,label,N,M,A,B,pai]=preexcute(path);
label_num='SBME';

%test
file_in = fopen('data_test2.txt','r');
test_sentence=fscanf(file_in,'%s');
fclose(file_in);
T=length(test_sentence);
delta=zeros(T,N);
fai=zeros(T,N);
delta(1,:)=pai.*(B(:,strfind(word_dic,test_sentence(1))) )';
delta(1,:)=delta(1,:)/sum(delta(1,:));
fai(1,:)=zeros(1,4);

for t=1:T-1
    for i=1:N
        tem_max_delta=zeros(1,N);
        tem_max_fai=zeros(1,N);
        tem_max_delta(1,:)=(delta(t,:)').*A(:,i)*B(i,strfind(word_dic,test_sentence(t+1)));
        tem_max_fai(1,:)=(delta(t,:)').*A(:,i);
        delta(t+1,i)=max(tem_max_delta);
        [~,index]=max(tem_max_fai);
        fai(t+1,i)=index;
    end
    delta(t+1,:)=delta(t+1,:)/sum(delta(t+1,:));
end


q=zeros(1,T);
[~,index]=max(delta(T,:));
q(1,T)=index;
for t=(T-1):-1:1
    q(1,t)=fai(t+1,q(1,t+1));
end

test_label='';
for i=1:length(test_sentence)
    test_label=strcat(test_label,label_num(q(i)));
end

res_sentence='';
for i=1:length(test_label)
    if(test_label(i)=='S' || test_label(i)=='B')
        res_sentence=sprintf('%s %s',res_sentence,test_sentence(i));  
    else
        res_sentence=sprintf('%s%s',res_sentence,test_sentence(i));  
    end
end
res_sentence
file_in = fopen('result.txt','w');
test_sentence=fprintf(file_in,'%s',res_sentence);
fclose(file_in);


