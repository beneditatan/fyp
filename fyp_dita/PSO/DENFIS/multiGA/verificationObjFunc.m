% Script used for verification of the algorithm's capabilities

function [fitness] = verificationObjFunc(u, opts)

generation = opts(1);
x = zeros(45, 1);
x(1) = opts(2);
fitness = x(1)^2 + u(1)^2;

for k = 2:45
	x(k) = x(k - 1) + u(k - 1);
	fitness = fitness + x(k)^2 + u(k)^2;
end
fitness = -fitness - (x(k) + u(k))^2;