function likelihoodsMatrix = ComputeDescriptorLikelihoods( descriptorSet1, descriptorSet2, parameters )
    
    % Compute likelihood distance matrix between two sets of multiscale covariance descriptors.
    %
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    descriptorSet1: (FxFxSCxN) first set of N FxF Covariance Descriptors, obtained at SC scales
    %    descriptorSet2: (FxFxSCxM) second set of M FxF Covariance Descriptors, obtained at SC scales
    %    parameters:     parameters struct
    % Returns:
    %    C: (NxM) game cost matrix
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    if parameters.verbose
        initialTime = tic;
    end

    nPointsScene1 = size( descriptorSet1, 4 );
    nPointsScene2 = size( descriptorSet2, 4 );
    featureDimension = size( descriptorSet1, 1 );

    eigsMatrix = zeros( nPointsScene1, nPointsScene2, numel( parameters.multiScaleRadius ), featureDimension );
    
    % Compute Foerstner distance for each pair of descriptors
    for sc = 1:numel( parameters.multiScaleRadius )
       for cd1 = 1:nPointsScene1
           referenceCovarianceDescriptor = descriptorSet1(:,:,sc,cd1);
           for cd2 = 1:nPointsScene2
               eigsMatrix( cd1, cd2, sc, : ) = eig( referenceCovarianceDescriptor, descriptorSet2(:,:,sc,cd2) );
           end
       end
    end
    logEigsMatrix = log( eigsMatrix );
    distsMatrix = real( sqrt( sum(logEigsMatrix.^2, 4 ) ) );
    
    % Remove bigger distance value
    likelihoodsMatrix = sum( distsMatrix, 3 ) - max( distsMatrix, [], 3 );
    
    if parameters.verbose
        totalTime = toc(initialTime);
        display(['Computed covariance descriptor likelihoods. Elapsed time = ', num2str(totalTime)]);
    end
    
end