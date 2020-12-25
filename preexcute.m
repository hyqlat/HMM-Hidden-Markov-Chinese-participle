function [sentence,word_dic,label,N,M,A,B,pai]=preexcute(path)
file_in = fopen(path,'r');
S_in=fscanf(file_in,'%s');
fclose(file_in);
label_word='S';
qian_gang=0;
label='';
sentence='';
word_dic='';
label_num='SBME';
j=1;
for i=S_in
    if(i=='|')
        if(label(j-1)=='M')
            label(j-1)='E';
        end
        label_word='S';
        qian_gang=1;
    elseif(j>1 && label(j-1)=='S' && qian_gang~=1)
        label(j-1)='B';
        label_word='M';
        label=strcat(label,label_word);
        temp=strfind(word_dic,i);
        if(isempty(temp))
           word_dic=strcat(word_dic,i);
        end
        sentence=strcat(sentence,i);
        j=j+1;
        qian_gang=0;
    else
        label=strcat(label,label_word);
        j=j+1;
        temp=strfind(word_dic,i);
        if(isempty(temp))
           word_dic=strcat(word_dic,i);
        end
        sentence=strcat(sentence,i);
        qian_gang=0;
    end
end
N=4;M=length(word_dic);T=length(sentence);

A=zeros(N,N);
B=zeros(N,M);
pai=rand(1,N);
pai(3)=0;pai(4)=0;
pai=pai/sum(pai);

for i=1:(length(label)-1)
    A(strfind(label_num,label(i)),strfind(label_num,label(i+1)))=A(strfind(label_num,label(i)),strfind(label_num,label(i+1)))+1;
end
for i=1:4
    A(i,:)=A(i,:)/sum(A(i,:));
end


for i=1:length(sentence)
    B(strfind(label_num,label(i)),strfind(word_dic,sentence(i)))=B(strfind(label_num,label(i)),strfind(word_dic,sentence(i)))+1;
end
for i=1:4
    B(i,:)=B(i,:)/sum(B(i,:));
end




end