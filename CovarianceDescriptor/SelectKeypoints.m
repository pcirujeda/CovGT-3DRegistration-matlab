function [ keyPoints, descriptorRadius ] = SelectKeypoints( scene, parameters )

    % Select keypoints from a scene according to a previous analysis using
    % Covariance Descriptors properties.
    %
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    scene: scene structure
    %    parameters: parameters structure
    % Returns:
    %    keypoints: (Nx4) set of N 3D keypoint coordinates and associated scene vertex IDs
    %    descriptorRadius: estimated descriptor radius according to scene volume
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    if parameters.verbose
        initialTime = tic;
    end
        
    % Align data to principal axis
    alignedScene = SceneAlignment( scene );
    sceneCoordinates = [alignedScene.feats.X, alignedScene.feats.Y, alignedScene.feats.Z];
    sceneNormals = [alignedScene.feats.nx, alignedScene.feats.ny, alignedScene.feats.nz];
    sceneColorVertices = [alignedScene.feats.R, alignedScene.feats.G, alignedScene.feats.B]./255;

    % Descriptor radius initial estimation as 5% of the scene bounding voxel norm
    descriptorRadius = 0.05 * norm( range( sceneCoordinates ));
        
    % Compute scene descriptors
    kdTree = kdtree_build( sceneCoordinates );
    for p = 1:size( sceneCoordinates, 1 )
        
        vIdxs = kdtree_ball_query( kdTree, sceneCoordinates(p, :), descriptorRadius);
        
        centerPoint = sceneCoordinates(p, :);
        centerNormal = sceneNormals(p, :);
        sceneDescriptors(:,:,p) = CovarianceDescriptor( centerPoint, centerNormal, ...
                                                        sceneCoordinates(vIdxs, :), ...
                                                        sceneNormals(vIdxs, :), ...
                                                        sceneColorVertices(vIdxs, :));
        determinantValues(p) = det( sceneDescriptors(:,:,p));
        rankValues(p) = rank( sceneDescriptors(:,:,p));    
    end
    kdtree_delete( kdTree );
    
    % Sample valid points in a voxel grid
    fullRankDeterminantValues = determinantValues( rankValues == 6 );
    fullRankCoordinateValues = sceneCoordinates( rankValues == 6, :);
    keyPointIdx = GridSamplePoints( [fullRankCoordinateValues, fullRankDeterminantValues'], parameters );

    % Get the set of original keypoint coordinates
    originalSceneCoordinates = [scene.feats.X, scene.feats.Y, scene.feats.Z];
    fullRankSceneCoordinates = originalSceneCoordinates(rankValues == 6,:);
    keyPoints = [ fullRankSceneCoordinates( keyPointIdx,: ), keyPointIdx ];
    
    % Perform relevance sampling    
    if parameters.relevanceSampling
        distinctivenessMap = DistinctivenessMap( keyPoints, originalSceneCoordinates, determinantValues, 0.7, 1 );
        maxDistinctivenessCentroids = peakfinder( distinctivenessMap, 10^-11 );
        keyPoints = keyPoints( maxDistinctivenessCentroids, : );
    end
    
    if parameters.verbose
        totalTime = toc(initialTime);
        display(['Selected ', num2str( size( keyPoints, 1 )) ' keypoints for ', scene.sceneName,'. Elapsed time = ', num2str(totalTime)]);
    end
end
    