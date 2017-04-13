function descriptorSet = ComputeDescriptors( scene, keyPoints, covRadius, parameters)

    % Compute set of Covariance Descriptors for a scene.
    %
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    scene:      scene structure
    %    keypoints:  (Nx4) set of N 3D keypoint coordinates + keypoint vertex ID
    %    covRadius:  float value for covariance descriptor radius
    %    parameters: parameters structure
    % Returns:
    %    descriptorSet: (FxFxSCxN) set of N FxF Covariance Descriptors, obtained at SC scales
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    if parameters.verbose
        initialTime = tic;
    end
   
    sceneCoordinates  = [scene.feats.X, scene.feats.Y, scene.feats.Z];
    sceneNormals      = [scene.feats.nx, scene.feats.ny, scene.feats.nz];
    sceneVertexColors = [scene.feats.R, scene.feats.G, scene.feats.B];

    descriptorSet = zeros( 6, 6, numel( parameters.multiScaleRadius ), size( keyPoints, 1 ) );
    
    kdTree = kdtree_build( sceneCoordinates );
    for i = 1:size( keyPoints, 1 )
        for sc = 1:numel( parameters.multiScaleRadius )
            vIdxs = kdtree_ball_query( kdTree, keyPoints(i,1:3), covRadius*parameters.multiScaleRadius(sc) );
        
            descriptorSet(:,:,sc,i) = CovarianceDescriptor( keyPoints(i,1:3), ...
                                                            sceneNormals(scene.feats.idx == keyPoints(i,4), :), ...
                                                            sceneCoordinates(vIdxs, :), ...
                                                            sceneNormals(vIdxs, :), ...
                                                            sceneVertexColors(vIdxs, :) );
        end
    end
    kdtree_delete( kdTree );
    
    if parameters.verbose
        totalTime = toc(initialTime);
        display( ['Computed covariance descriptors for ', scene.sceneName, '. Elapsed time = ', num2str(totalTime) ]);
    end
end