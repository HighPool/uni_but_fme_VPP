clear;clc;clf
%rng(1);

% dt = 1; N_k = 0.1; N = 20; 
% A = 1; C = 1; M_k = 0;
% x0 = 1;
% x0_hat = 0; S = 1000;
% 
% x = ones(1, N+1);
% z = x + chol(N_k)'*randn(1,N+1);
% 
% x_hat_kp_k = zeros(1, N+1); sigma_hat_kp_k = zeros(1, N+1);
% x_hat_k_k = zeros(1, N+1); sigma_hat_k_k = zeros(1, N+1);
% 
% x_hat_kp_k(1) = x0_hat; sigma_hat_kp_k(1) = S;
% 
% for k=0:N-1
%      %update
%      K_gain = sigma_hat_kp_k(k+1)*C'*inv(C*sigma_hat_kp_k(k+1)*C'+N_k);
%      x_hat_k_k(k+1) = x_hat_kp_k(k+1) + K_gain*(z(k+1)-C*x_hat_kp_k(k+1));
%      sigma_hat_k_k(k+1) = sigma_hat_kp_k(k+1) - K_gain*C*sigma_hat_kp_k(k+1);
% 
%      %prediction
%      x_hat_kp_k(k+2) = A*x_hat_k_k(k+1);
%      sigma_hat_kp_k(k+2) = A*sigma_hat_k_k(k+1) + M_k;
% end
% 
% %update
% k = N;
% K_gain = sigma_hat_kp_k(k+1)*C'*inv(C*sigma_hat_kp_k(k+1)*C'+N_k);
% x_hat_k_k(k+1) = x_hat_kp_k(k+1) + K_gain*(z(k+1)-C*x_hat_kp_k(k+1));
% sigma_hat_k_k(k+1) = sigma_hat_kp_k(k+1) - K_gain*C*sigma_hat_kp_k(k+1);

dt = 1; N_k = 0.1; N = 100; 
A = [1 dt; 0 1]; C = [1 0]; M_k = [0.001 0.0005; 0.0005 0.0008];
x0 = [0,0.1];
s = 1000;
x0_hat = [1,0]; S = diag([s,s]);

x = ones(2, N+1);
z = zeros(1,N+1);

x(:,1) = x0;
z(1) = C*x(:,1) + chol(N_k)'*randn(1,1);

for i=1:N
    x(:,i+1) = A*x(:,i) + chol(M_k)'*randn(2,1);
    z(i+1) = C*x(:,i+1) + chol(N_k)'*randn(1,1);
end

x_hat_kp_k = zeros(2, N+1); sigma_hat_kp_k = zeros(2,2, N+1);
x_hat_k_k = zeros(2, N+1); sigma_hat_k_k = zeros(2,2, N+1);

x_hat_kp_k(:,1) = x0_hat; sigma_hat_kp_k(:,:,1) = S;

for k=0:N-1
     %update
     K_gain = sigma_hat_kp_k(:,:,k+1)*C'*inv(C*sigma_hat_kp_k(:,:,k+1)*C'+N_k);
     x_hat_k_k(:,k+1) = x_hat_kp_k(:,k+1) + K_gain*(z(k+1)-C*x_hat_kp_k(:,k+1));
     sigma_hat_k_k(:,:,k+1) = sigma_hat_kp_k(:,:,k+1) - K_gain*C*sigma_hat_kp_k(:,:,k+1);

     %prediction
     x_hat_kp_k(:,k+2) = A*x_hat_k_k(:,k+1);
     sigma_hat_kp_k(:,:,k+2) = A*sigma_hat_k_k(:,:,k+1) + M_k;
end

%update
k = N;
K_gain = sigma_hat_kp_k(:,:,k+1)*C'*inv(C*sigma_hat_kp_k(:,:,k+1)*C'+N_k);
x_hat_k_k(:,k+1) = x_hat_kp_k(:,k+1) + K_gain*(z(k+1)-C*x_hat_kp_k(:,k+1));
sigma_hat_k_k(:,:,k+1) = sigma_hat_kp_k(:,:,k+1) - K_gain*C*sigma_hat_kp_k(:,:,k+1);

hold on
plot(0:N,x(1,:),"ko--")
plot(0:N,z,"rx--")
plot(0:N,x_hat_k_k(1,:),"bo--")
