clear;clc;
c1  = @(x) sqrt(0.9*x);
c2 = @(u) (u>0)*(0.3+u);
c3 = @(x,w) -3*min(x,w);

%cenove f-ce 
g_k = @(x,u,w) c1(x) + c2(u) + c3(x,w) ;
g_N = @(x) c1(x);

M = 4; U = 3; N = 15;
xs=[0:M]'; us=[0:U]'; ss=us;
ws=[0:3]'; ps=[0.1;0.3;0.5;0.1];
nr_states = (M+1)*(U+1);%pocet ruznych stavu
states = zeros(nr_states,2);

%kombinace stavu
iter=0;
for i=1:length(xs)
    for ii=1:length(ss)
        iter = iter+1;
        states(iter,:) = [xs(i),ss(ii)];
    end
end

J=zeros(nr_states,N+1); mu=zeros(nr_states,N);
for i = 1:nr_states % J_N=g_N(x)
    x_cur = states(i,1);
    J(i,end) = g_N(x_cur);
end

for i = N:-1:1
    for ii = 1:nr_states
        J_temp = zeros(length(us),1);
        for iii = 1:length(us)
            for iiii = 1:length(ws)
                x_cur = states(ii,1);
                s_cur = states(ii,2);
                u_cur = us(iii);
                w_cur = ws(iiii);

                %pristi stav
                x_next = min(max(x_cur-w_cur,0) + s_cur,M);
                s_next = u_cur;

                states_row = find(x_next==states(:,1) & s_next==states(:,2));
                
                J_temp(iii) = J_temp(iii) + ps(iiii)*(g_k(x_cur,u_cur,w_cur)+J(states_row,i+1));
            end
        end
        [minval,minpos] = min(J_temp);
        J(ii,i)=minval;mu(ii,i)=us(minpos);
    end
end
states
J
