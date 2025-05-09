function m385bvp1d
% template for numerical solution of a two-point boundary value problem
% -y''=r, y(0)=alpha, y(1)=beta
clear; clf;
alpha = 0; beta = 1; lambda = 25;   % boundary conditions
for icase=1:4
    n = 2^icase-1; h = 1/(n+1);     % h = mesh size
    xe = 0:0.0025:1;                % fine mesh for plotting exact solution
    ye = 25/(pi*pi)*sin(pi*xe)+xe;                          % exact solution on fine mesh
% Set up for numerical solution.
for i=1:n
    xh(i) = i*h;                    % mesh points
    yh(i) = 25/(pi*pi)*sin(pi*xh(i))+xh(i);                       % exact solution at mesh points
    a(i) = -1; b(i) = 2; c(i) = -1;      % matrix elements
    r(i) = 25*sin(pi*xh(i));                        % right hand side vector
end
    r(1) = r(1)+alpha/(h*h);                        % adjust for BC at x=0
    r(n) = r(n)+beta/(h*h);                        % adjust for BC at x=1
    wh = (h^2)*LU_385(a,b,c,r);     % numerical solution
% output
    table(icase,1) = h;
    table(icase,2) = norm(yh-wh,inf);
    table(icase,3) = norm(yh-wh,inf)/h;
    table(icase,4) = norm(yh-wh,inf)/h^2;
    table(icase,5) = norm(yh-wh,inf)/h^3;
    xplot = [0 xh 1]; wplot = [alpha wh beta];
    subplot(2,2,icase); plot(xe,ye,xplot,wplot,'-o');
    string = sprintf('h=1/%d',n+1); title(string)
end
table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w = LU_385(a,b,c,r)
% input: a, b, c, r - matrix elements and right hand side vector
% output: w - solution of linear system
%
n = length(r);                      %size of vector r
% find L, U
u(1)=b(1);
for k=2:n
  l(k)=a(k)/u(k-1);
  u(k)=b(k)-l(k)*c(k-1);
end
% solve Lz = r
z(1)=r(1);
for k=2:n
  z(k)=r(k)-l(k)*z(k-1);
end
% solve Uw = z
w(n)=z(n)/u(n);
for k=n-1:-1:1
  w(k)=(z(k)-c(k)*w(k+1))/u(k);
end
