K=3;
prompt="Please Enter The Value Of L";
L=input(prompt);
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
