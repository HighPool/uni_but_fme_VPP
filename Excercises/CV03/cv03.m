xs = [1:5]'; us = [1:3]'; N =10;
W = zeros(5,5,3);

%u=1
W(1,1,1) = 0.6; W(1,2,1) = 0.3; W(1,3,1) = 0.1;
W(2,2,1) = 0.7; W(2,3,1) = 0.2; W(2,4,1) = 0.1;
W(3,3,1) = 0.75; W(3,4,1) = 0.15; W(3,5,1) = 0.1;
W(4,4,1) = 0.8; W(4,5,1) = 0.2;
W(5,5,1) = 1;

% u=2
W(2,1,2) = 0.9; W(2,2,2) = 0.1;
W(3,2,2) = 0.9; W(3,3,2) = 0.1;
W(4,3,2) = 0.9; W(4,4,2) = 0.1;
W(5,4,2) = 0.9; W(5,5,2) = 0.1;

% u=3
W(2:5,1,3) = 1;

g_p = [1, 0.9, 0.6, 0.4, 0];
g_a = [0,-0.4,-1];

J = zeros(5,N+1); mu=zeros(5,N);
J(:,N+1) = g_p;

for i=N:-1:1
    for ii=1:5
        x_cur = xs(ii);
        J_temp = zeros(3,1);
        for iii=1:3
            u_cur=us(iii);
            w_cur = W(x_cur,:,u_cur);
            if sum(w_cur) > 0
                % J_temp(iii) = g_p(ii) + g_a(iii) + w_cur*J(:,i+1);
                J_temp(iii) = g_p(ii) + g_a(iii) + min(J(w_cur>0,i+1));
            else
                J_temp(iii) = -Inf;
            end 
        end
        [maxval,maxpos] = max(J_temp);
        J(ii,i) = maxval; mu(ii,i)=us(maxpos);
    end
end

%simulator
n = 1000; x0 = 1 ;
J_sim = zeros(n,1); x_sim=zeros(n,N+1); x_sim(:,1) = x0;
for iter = 1:n
    for i = 1:N
        x_cur = x_sim(iter,i);
        u_cur = mu(x_cur,i);
        J_sim(iter) = J_sim(iter) + g_p(x_cur) + g_a(u_cur);
        w = W(x_cur,:,u_cur);
        r = rand;
        idxs = find(r < cumsum(w));
        x_sim(iter,i+1) = idxs(1); 
    end
    J_sim(iter) = J_sim(iter) + g_p(x_sim(iter,end)); 
end

[min(J_sim), mean(J_sim), J(1,1)]