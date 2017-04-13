function MCOV = CovarianceDescriptor( descriptorCenter, centerNormal, neighborhoodPoints, neighborhoodNormals, neighborhoodColors ) 
   
    % Compute a Covariance Descriptor for a given 3D point and a set of
    % neighboring points with associated normal vectors and color values.
    %
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    descriptorCenter:    (1x3) descriptor center coordinates
    %    centerNormal:        (1x3) descriptor center normal vector
    %    neighborhoodPoints:  (Nx3) descriptor region coordinates
    %    neighborhoodNormals: (Nx3) descriptor region normal vectors
    %    neighborhoodColors:  (Nx3) descriptor region RGB color values
    % Returns:
    %    MCOV: (6x6) Covariance Descriptor
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    MCOV = eye(6);
    
    nSamples = size(neighborhoodPoints,1);
    if nSamples > 10
  
        segments = (neighborhoodPoints - repmat(descriptorCenter, nSamples, 1));
        segments = segments ./ repmat((sqrt(sum((segments).^2, 2))), 1, 3);

        alpha = real(acos(dot(repmat(centerNormal, nSamples, 1), segments, 2))/pi);
        beta  = real(acos(dot(neighborhoodNormals, -segments, 2))/pi);
        gamma = real(acos(dot(repmat(centerNormal, nSamples, 1), neighborhoodNormals, 2))/pi);
        
        alpha(isnan(alpha)) = 0;
        beta(isnan(beta))   = 0;
        gamma(isnan(gamma)) = 0;
        
        feats = [neighborhoodColors(:,1), neighborhoodColors(:,2), neighborhoodColors(:,3), alpha, beta, gamma];

        MCOV = feats.' * feats ./ nSamples;
    end
           
end