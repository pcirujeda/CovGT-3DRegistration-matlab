function [ R, T ] = WeightedAbsoluteOrientation( P, Q, W )

    % Solves the weighted absolute orientation problem for finding a rigid
    % transformation which translates point set P to Q.
    %
    % Inputs:
    %     P: (3xN) reference point set
    %     Q: (3xN) target point set (P after some transformation)
    %     W: (1xN) point confidence weights. Optional.
    % Returns:
    %     R: (3x3) estimated rotation matrix
    %     T: (1x3) estimated translation vector    
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Xavier Mateo
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    nPoints = size( P,2 );

    % Assign uniform weight values if not specified
    if ~exist( 'W', 'var' )
        W = ones(1, nPoints) / nPoints;
    end

    % Normalize weights
    W = W / sum( W );
    
    % Weight points
    Pm = P .* repmat( W, 3, 1);
    Qm = Q .* repmat( W, 3, 1);

    % Compute means of P and Q
    pbar = sum( Pm, 2 );
    qbar = sum( Qm, 2 );
    for i = 1:nPoints
      PP(:,i) = P(:,i) - pbar;
      QQ(:,i) = Q(:,i) - qbar;
    end

    % Compute M matrix
    M(1:3,1:3) = 0;
    for i = 1:nPoints
      M = M + PP(:,i) * QQ(:,i).';
    end

    % Calculate SVD of M
    [U,~,V] = svd(M);

    % Compose the optimal estimate of R and T
    R = V * (U.');
    T = qbar - R * pbar;
end
