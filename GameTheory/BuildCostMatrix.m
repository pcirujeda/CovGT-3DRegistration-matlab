function C = BuildCostMatrix( keyPointsScene1, keyPointsScene2, correspondences )

    % Computes the cost matrix associated to a non-cooperative matching
    % game given a set of points associated to previous descriptor matching
    % likelihood values.
    % 
    % Method details described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    keyPointsScene1: (Nx4) matrix containing 3D keypoint coordinates + original scene vertex indices
    %    keyPointsScene2: (Mx4) keypoints matrix for second scene
    %    correspondences: (Px3) set of correspondences specifying keypoint index matches and covariance descriptor likelihood values
    % Returns:
    %    C: (NxM) game cost matrix
    %
    % Author : Pol Cirujeda / github.com/pcirujeda
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
   
    % Compute descriptor likelihood payoff
    descriptorPayoff = exp( - correspondences(:,3) * correspondences(:,3)' );

    % Compute geometric payoff
    scene1Coordinates = keyPointsScene1( correspondences(:,1), 1:3 );
    scene2Coordinates = keyPointsScene2( correspondences(:,2), 1:3);
    intraDistsScene1 = dist( scene1Coordinates, scene1Coordinates' );
    intraDistsScene2 = dist( scene2Coordinates, scene2Coordinates' );
    
    % Normalize geometric distances
    maxDist = max( [intraDistsScene1(:); intraDistsScene2(:)] );
    intraDistsScene1 = intraDistsScene1 / maxDist;
    intraDistsScene2 = intraDistsScene2 / maxDist;
    
    minIntraDistPayoff = min( intraDistsScene1, intraDistsScene2 );
    maxIntraDistPayoff = max( intraDistsScene1, intraDistsScene2 );
    difIntraDistPayoff = exp( -abs( intraDistsScene1 - intraDistsScene2 ) );
    
    % Compute aggregated payoff matrix
    C = descriptorPayoff .* minIntraDistPayoff .* difIntraDistPayoff ./ ( maxIntraDistPayoff + eps );
    
    % Remove diagonal since they are not significant game matches
    C = C - diag( diag(C) );
    
end
