function p = multiplyGaussian(X, mu, Sigma2)

if sum(Sigma2==0) > 0
    error('there is zero element in Sigma2');
end

Sigma2Inv = Sigma2.^(-1);
if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
    Sigma2 = diag(Sigma2);
    Sigma2Inv = diag(Sigma2Inv);
end

k = length(mu);
m = size(X,1);

p = zeros(m,1); % hided by Holy 1809271417

X = bsxfun(@minus, X, mu(:)');

% hided by Holy 1809271414
parfor i = 1:m
    p(i) = (2 * pi) ^ (- k / 2) * det(Sigma2) ^ (-0.5) * ...
    exp(-0.5 * X(i,:)*Sigma2Inv*X(i,:)');
end
% end of hide 1809271414

% added by Holy 1809271415
% p = (2 * pi) ^ (- k / 2) * det(Sigma2) ^ (-0.5) * ...
%     exp(-0.5 * sum(bsxfun(@times, X * Sigma2Inv, X), 2));
% end of addition 1809271415

% hided by Holy 1809271052
% if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
%     Sigma2 = diag(Sigma2);
% end
% 
% X = bsxfun(@minus, X, mu(:)');
% p = (2 * pi) ^ (- k / 2) * det(Sigma2) ^ (-0.5) * ...
%     exp(-0.5 * sum(bsxfun(@times, X * pinv(Sigma2), X), 2));
% end of hide 1809271052
end