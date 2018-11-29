function distinctivenessMap = DistinctivenessMap( keyPoints, coordinates, determinants, T, k )
   
    % Compute the distinctiveness map for a set of keypoints for relevance
    % sampling based on Covariance Descriptor generalized variances
    % (determinant values).
    %
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    keypoints:    (Nx4) set of 3D keypoint coordinates and keypoint vertex IDs
    %    coordinates:  (Mx3) scene 3D points
    %    determinants: (Nx1) set of keypoint descriptor determinant values
    %    T:            relevance threshold coefficient
    %    k:            sparsity factor
    % Returns:
    %    distinctivenessMap: (Nx1) keypoint associated relevance magnitude
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
  
    % Normalize determinant values
    maxDet = max( determinants );
    determinants = determinants/maxDet;
    
    distinctivenessMap = zeros(1,size(keyPoints,1));
    
    kdTree = KDTreeSearcher( coordinates(:,1:3) );
    for idX=1:size( keyPoints, 1 )
        neigh = cell2mat( rangesearch( kdTree, keyPoints(idX, 1:3), 5 ) );
        q = neigh(ismember(neigh, keyPoints(:,4)));
        
        detP = determinants( idX );
        detQ = determinants( q );
        relevance = detP - detQ;
        
        Ap = coordinates( q(relevance > T*maxDet), : );
        
        if ~isempty(Ap)
            distinctivenessMap( idX ) = norm(Ap)^(-k);
        end
    end    

end