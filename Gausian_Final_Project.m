%                      Programmer:- NILAY SHAH
%                      Programme :-Convolutional Codes
%                      ID:-201901026
SNRdB=0:0.5:8;
er=0;

for ksim=1:1:20000
%Encoder
close all;
K=3;
%prompt="Please Enter The Value Of L";
%L=input(prompt);
L=500;
j=L;
a=zeros(1,100000);
m=randi([0,1],1,L);
app=[0 0];
m=cat(2,m,app);
message=m;
%%%%%%%display(m);
m=cat(2,m,a);
m1=m(1);
m2=0;
m3=0;
i=1;
x=[];

while(L+2>=1)
    
    p1=mod(m1+m2+m3,2);
    p2=mod(m1+m3,2);  
     
     
x=cat(2,x,p1,p2);

m3=m2;
m2=m1;
m1=m(i+1);

i=i+1;
L=L-1;
end

%%%%%%%display(x);
L=j;

%MONTE-carlo

%BSC Channel
L=j;
r1=1/2;
SNRdB=5;
SNRlin=10.^(SNRdB/10);
j=sqrt(2*r1*SNRlin);
pError=qfunc(j);
Xbsc=x;
nError=pError*((2*L)+4);
nError=floor(nError);
count=0;
nj=1;
fj=randperm((2*L)+4,nError);
    fj=sort(fj);
    s=zeros(1,10000);
    fj=cat(2,fj,s);
for i=1:((2*L)+4)
    
    if(i==fj(nj))
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
%%%%%%%display(Xbsc);
            
%BEC channel            
    Xbec=x;
   nj=1; 
for i=1:((2*L)+4) 
    if(i==fj(nj))
        if(Xbec(i)==1 || Xbec(i)==0)
             Xbec(i)=8;   
        end  
        nj=nj+1;
    end
end
%%%%%%%display(Xbec);
r1=1/2;
       %Gaussian Channel     
            s=x;
            for i=1:((2*L)+4)
                s(i)=2*x(i)-1;
            end
            %%%%%%%display(s);
        SNRdB=1:((2*L)+4);    
        SNRlin = 10.^(SNRdB/10);
        
        sigma2=(1./(2*r1.*SNRlin));
        sigma=sqrt(sigma2);
        n=sigma*randn;
        r=s+n;
        %%%%%%%display(r);
            %DECODER            
state=[0 1 26 26;26 26 0 1;0 1 26 26;26 26 0 1];
op=[1 4 26 26;26 26 4 1;2 3 26 26;26 26 3 2];
trellis=[0 inf inf inf];
d=zeros(L+2,4);
trellis=cat(1,trellis,d);
Bm=[];
       rcvd=[0 0;1 0;0 1;1 1];
       for i=1:2:2*L+4
           k=[];
           for j=1:4
               rt1=(r(i)-rcvd(j))*(r(i)-rcvd(j));
               rt2=(r(i+1)-rcvd(4+j))*(r(i+1)-rcvd(4+j));
               s=rt1+rt2;
              k=cat(2,k,s);
           end
          Bm=cat(1,Bm,k);
       end
       
       for PRS=2:1:L+3
         
               x1=trellis(PRS-1)+Bm(PRS-1);
               x2=trellis((PRS-1)+(2*(L+3)))+Bm((PRS-1)+(3*(L+2)));
               trellis(PRS)=min(x1,x2);
      
              x1=trellis(((PRS-1)))+Bm((PRS-1)+((L+2)));
              x2=trellis((PRS-1)+(2*(L+3)))+Bm((PRS-1));
           trellis((PRS)+(L+3))=min(x1,x2);
             x1=trellis((PRS-1)+(L+3))+Bm((PRS-1)+((L+2)));
             x2=trellis((PRS-1)+3*(L+3))+Bm((PRS-1)+(2*(L+2)));
                 trellis((PRS)+(2*(L+3)))=min(x1,x2);
               x1=trellis((PRS-1)+(L+3))+Bm((PRS-1)+(2*(L+2)));
               x2=trellis((PRS-1)+(3*(L+3)))+Bm((PRS-1)+(L+2));
              trellis((PRS)+(3*(L+3)))=min(x1,x2);
       end
%%%%%%%display(trellis);

%Trace
trace=[];
temp=1;

for PRS=L+3:-1:2
    
    if(temp==1)
        h=min(trellis(PRS-1),trellis((PRS-1)+(2*(L+3))));
        if(h==trellis(PRS-1))
            trace=cat(1,trace,1);
            temp=1;
        else
            
            trace=cat(1,trace,3); 
            temp=3;
        end
        continue;
    end
    
    if(temp==2)

        h=min(trellis((PRS-1)+(2*(L+3))),trellis((PRS-1)));
        if(h==trellis((PRS-1)+(2*(L+3))))
            
    trace=cat(1,trace,3);
    temp=3;
        else
           
            trace=cat(1,trace,1);
            temp=1;
        end
         continue;
    end
    
if(temp==3)
    
        h=min(trellis((PRS-1)+(L+3)),trellis((PRS-1)+(3*(L+3))));
        if(h==trellis((PRS-1)+(L+3)))
           
    trace=cat(1,trace,2);
    temp=2;
        else
           
            trace=cat(1,trace,4);
            temp=4;
        end
         continue;
end
    
    if(temp==4)
        h=min(trellis((PRS-1)+((L+3))),trellis((PRS-1)+(3*(L+3))));
        if(h==trellis((PRS-1)+(L+3)))
            
    trace=cat(1,trace,2);
    temp=2;
    
        else 
            
            trace=cat(1,trace,4);
            temp=4;
        end
         continue;
    end
     
end
trace=flip(trace);
trace=cat(1,trace,1);
track=[1 1 0;1 2 1;2 3 0;2 4 1;3 1 0;3 2 1;4 3 0;4 4 1];
j=1;
decode=zeros(1,L+2);
for i=1:L+2
   
    if(trace(i)==1 && trace(i+1)==1)
        decode(j)=0;
        j=j+1;
        continue;
    end
 if(trace(i)==1 && trace(i+1)==2)
     decode(j)=1;
     j=j+1;
     continue;
 end
 if(trace(i)==2 && trace(i+1)==3)
     decode(j)=0;
     j=j+1;
     continue;
 end
 
if(trace(i)==2 && trace(i+1)==4)
    decode(j)=1;
    j=j+1;
    continue;
end
  if(trace(i)==3 && trace(i+1)==1)
        decode(j)=0;
        j=j+1;
        continue;
    end
 if(trace(i)==3 && trace(i+1)==2)
     decode(j)=1;
     j=j+1;
     continue;
 end
  if(trace(i)==4 && trace(i+1)==3)
        decode(j)=0;
        j=j+1;
        continue;
        
  end
 if(trace(i)==4 && trace(i+1)==4)
     decode(j)=1;
     j=j+1;
     continue;
 end
end
 %%%%%%%display(decode);
 %%%%%%%display(message);
 error=0;
 for i=1:L+2
     if(decode(i)~=message(i))
         error=error+1;
     end
 end
 %%%%%%%display(error);
 er=er+error/(L+2);
end
average=er/(L+2);
Pb=average/500;
display(Pb);