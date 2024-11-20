clear;clc;

dt = 1; 
N = 100; x0 = [0;0.1];
x0_hat = [0;0]; S = diag([1000,1000]); 
M_k = [0.001, 0.0005; 0.0005, 0.0008]; %system noise
N_k = 0.1; %measurement noise
C = [1 0]; A = [1 dt; 0 1];
G = eye(2);
B = [0
     0];

D = 0;

Plant = ss(A,[B G],C,D,dt,'InputName',{'u' 'w1' 'w2'},'OutputName','yt');
[kalmf,L,P,Mx,Z] = kalman(Plant,M_k,N_k,0);

vIn = sumblk('y=yt+v');

kalmf.InputName = {'u','y'};
kalmf.OutputName = 'ye';

SimModel = connect(Plant,vIn,kalmf,{'u','w1','w2','v'},{'yt','ye'});
t = (0:N)';
u = ones(size(t));

%rng(1,'twister');
w = mvnrnd(zeros(2,1),M_k,length(t));
v = sqrt(N_k)*randn(length(t),1);
out = lsim(SimModel,[u,w,v]);
yt = out(:,1);   % true response
ye = out(:,2);  % filtered response
y = yt + v;     % measured response

clf
subplot(211), plot(t,yt,'b',t,ye,'r--'), 
xlabel('Number of Samples'), ylabel('Output')
title('Kalman Filter Response')
legend('True','Filtered')
subplot(212), plot(t,yt-y,'g',t,yt-ye,'r--'),
xlabel('Number of Samples'), ylabel('Error')
legend('True - measured','True - filtered')

