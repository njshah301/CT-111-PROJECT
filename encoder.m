%Encoder
close all;
K=3;
prompt="Please Enter The Value Of L";
L=input(prompt);
j=L;
a=zeros(1,100000);
m=randi([0,1],1,L);
app=[0 0];
m=cat(2,m,app);
display(m);
m=cat(2,m,a);
m1=m(1);
m2=0;
m3=0;
i=1;
x=[];

while(L+2>=1)
    
    p1=mod(m1+m2+m3,2);
    p2=mod(m1+m2,2);  
     
     
x=cat(2,x,p1,p2);

m3=m2;
m2=m1;
m1=m(i+1);

i=i+1;
L=L-1;
end

display(x);
L=j;

%BSC Channel

L=j;
pError=0.5;
Xbsc=x;
nError=pError*(2*L+4);
nError=floor(nError);
count=0;
nj=1;
k=randperm((2*L)+4,nError);
    k=sort(k);
    s=zeros(1,10000);
    k=cat(2,k,s);
for i=1:((2*L)+4)
    
    if(i==k(nj))
        if(Xbsc(i)==1)
             Xbsc(i)='0';   
        end
        if(Xbsc(i)==0)
            Xbsc(i)=1;
        end
        
        nj=nj+1;
    end
end
for i=1:((2*L)+4)
    if(Xbsc(i)==48)
        Xbsc(i)=mod(48,2);
    end
end
display(Xbsc);
            
%BEC channel            
    Xbec=x;
   nj=1; 
for i=1:((2*L)+4)
    
    if(i==k(nj))
        if(Xbec(i)==1 || Xbec(i)==0)
             Xbec(i)=8;   
        end  
        nj=nj+1;
    end
end

display(Xbec);
       %Gaussian Channel     
            s=x;
            for i=1:((2*L)+4)
                s(i)=2*x(i)-1;
            end
            display(s);
        SNRdB=1:((2*L)+4);    
        SNRlin = 10.^(SNRdB/10);
        r1=1/2;
        sigma2=(1./(2*r1.*SNRlin));
        sigma=sqrt(sigma2);
        n=sigma*randn;
        r=s+n;
        display(r);
            