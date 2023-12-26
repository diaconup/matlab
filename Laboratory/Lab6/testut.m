load("lab5_3.mat")

% identificarea
Ui = id.u;
figure, 
plot(Ui), xlabel('x'), ylabel('y')
title('Date identificare - intrare')


Yi = id.y;
figure,
plot(Yi),xlabel('x'), ylabel('y')
title('Date identificare - iesire')

% semnalele de identificare nu sunt de medie zero

Ui = detrend(Ui);
figure, 
plot(Ui), xlabel('x'), ylabel('y')
title('Date identificare - intrare (medie zero)')

Yi = detrend(Yi);
figure,
plot(Yi),xlabel('x'), ylabel('y')
title('Date identificare - iesire (medie zero)')

%validarea
Uv = val.u;
figure,
plot(Uv),xlabel('x'), ylabel('y')
title('Date validare - intrare')

Yv = val.y;
figure, plot(Yv),xlabel('x'), ylabel('y')
title('Date validare - iesire')


[c, tau] = xcorr(Ui)
figure
plot(c, tau)


N = length(Ui)
err = struct([])
n = 0;

%construirea Ryu
Ru = [];
Ryu = [];
for i = 1:N
        s1 = 0;
        s2 = 0;
        for j = 1:(N-i)
            s1 = s1+Ui(j+i-1)*Ui(j);
            s2 = s2+Yi(j+i-1)*Ui(j);
        end
        Ru(i) = s1/N;
        Ryu(i) = s2/N;
end
RyuT = Ryu';    
    
for M = 45:90
    n = n+1;
   
    %construirea Ru - matrice
    Rufin = [];
    for i = 1:N
        for j = 1:M
            Rufin(i,j) = Ru(abs(i-j)+1);
        end     
    end
    
    H = Rufin\RyuT;    
    
    YhatId = conv(H,Ui);
    YhatId = YhatId(1:length(Yi));  %lungime diferita => trunchiere
    
    %MSE ID
    l = length(YhatId);
    err(n).id = round(1/l*sum((YhatId-Yi).^2),4);
    
    YhatVal = conv(H,Uv);
    YhatVal = YhatVal(1:length(Uv)) %lungime diferita => trunchiere
    
    %MSE Val
    l = length(YhatVal);
    err(n).val = round(1/l*sum((YhatVal-Yv).^2),4);

end

figure,
plot([err.id],'-o','Color',[0.4660 0.6740 0.1880]), title('MSE_i_d')
ylabel('err'), xlabel('n')
figure,
plot([err.val],'-o','Color',[0.4660 0.6740 0.1880]), title('MSE_v_a_l')
ylabel('err'), xlabel('n')

% din MSE val => best approximation pt M=53

M = 53;

Rufin = [];
    for i = 1:N
        for j = 1:M
            Rufin(i,j) = Ru(abs(i-j)+1);
        end     
    end
H = Rufin\RyuT;
figure,
plot(H), title('Reprezentare funcția pondere H')
hold on, plot(imp)
    
YhatId = conv(H,Ui);
YhatId = YhatId(1:length(Yi));  %lungime diferita => trunchiere
    
%MSE ID
l = length(YhatId);
mse1 = round(1/l*sum((YhatId-Yi).^2),4);
    
figure, 
plot(Yi), hold on
plot(YhatId), title('MSE_i_d=',mse1)
legend('Y system','Y FIR')


YhatVal = conv(H,Uv);
YhatVal = YhatVal(1:length(Uv)) %lungime diferita => trunchiere
    
%MSE Val
l = length(YhatVal);
mse2 = round(1/l*sum((YhatVal-Yv).^2),4);
    
figure, 
plot(Yv), hold on
plot(YhatVal), title('MSE_i_d=',mse2)
legend('Y system','Y FIR')


