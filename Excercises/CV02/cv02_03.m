%% roommate
clear;clc;clf;
x0 = 1; N = 3; alph = 0.8;
lambda = 0.25; p = 0.2; 
alph_bar = alph*(p*sqrt(1-lambda)+(1-p));
gamma_r = zeros(N,1);
for i=2:N
   gamma_r(i)=alph_bar*sqrt(1+gamma_r(i-1)^2); 
end
V0 = -2*sqrt(gamma_r(N)^2+1)*sqrt(x0)

%% simulace
n_scen = 1000;
val = zeros(n_scen,1);
for j=1:n_scen
    w = lambda*(rand(N,1)<p);
    us_r = zeros(N,1); vs_r = zeros(N+1,1); xs_r = zeros(N+1,1); xs_r(1) = x0;
    roommate = zeros(N,1);
    for i=1:N
        us_r(i) = xs_r(i)/(gamma_r(N-i+1)^2+1);
        vs_r(i) = -2*sqrt(gamma_r(N-i+1)^2+1)*sqrt(xs_r(i));
        xs_r(i+1) = (1-w(i))*(xs_r(i)-us_r(i));
        roommate(i) = xs_r(i)-us_r(i) - xs_r(i+1);
    end
    val(j,1) = sum(-2*sqrt(us_r).*(alph.^[0:N-1])');
end

mean(val)
pie([us_r;roommate(1:2)],{'day 1','day 2','day 3','rmmt 1', 'rmmt 2'})