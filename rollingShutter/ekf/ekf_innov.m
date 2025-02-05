function innovation = ekf_innov (x_k_k, dt, y_k, z_k, K, Kinv)

% Jul 2012 by Chao Jia
% evaluate the innovation vector

feature_num = length(y_k)/2;
x_num = length(x_k_k)/3;
Q = [0 1 0; -1 0 0; 0 0 1]*[1 0 0; 0 -1 0;0 0 -1];
py = zeros(feature_num*2,1);

for i = 1:feature_num
	% compute homography
	% find time interval for each angular velocity
	r_seq = r_gen(x_k_k, dt(:,i));
	R = eye(3);
	for j=x_num:-1:1
		R = R*r_seq(:,:,j);
	end
	hom = K*Q'*R*Q*Kinv;
	yy = hom*[y_k(2*i-1:2*i);1];
	py((2*i-1):2*i) = yy(1:2)./yy(3);
end

innovation = (z_k - py).^2;
innovation = reshape(innovation, 2, feature_num);
innovation = (sum(innovation))'./2;