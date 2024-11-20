clear; clc;
x0 = 1; N = 3; alpha = 0.8;
nb_points = 100;
xs = linspace(0,1,nb_points)';
g_k = @(u_k) -2*sqrt(u_k);
g_N = @(x) 0;

J = NaN*zeros(nb_points,N+1);
mu = NaN*zeros(nb_points,N);

for i=1:nb_points
    J(i,N+1)=g_N(xs(i));
end

for i=N:-1:1
    for ii=1:nb_points
        us = xs(1:ii);
        nb_pos = length(us);
        J_temp = zeros(nb_pos,1);
        for iii=1:nb_pos
            x_next = xs(ii-iii+1); % x_next = xs - u
            row = ii - iii +1;
            J_temp(iii) = g_k(us(iii)) + alpha*J(row,i+1);
        end
        [minval,minpos] = min(J_temp);
        J(ii,i) = minval; mu(ii,i) = us(minpos);
    end
end

%%eating - checking if correct%%
% have to be computade separately beacauses of backward-run
x = x0; %starting size
u_opt = zeros(N,1); %optimal choice arr

for i=1:N
   
    [~, idx] = min(abs(xs - x)); %closest value to current x
    u_opt(i) = mu(idx,i); %choosing correct control
    x = x - u_opt(i); %computing new x 
end
pie(u_opt)
