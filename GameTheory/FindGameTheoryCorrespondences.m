function gameWinners = FindGameTheoryCorrespondences( keyPointsScene1, keyPointsScene2, correspondences, parameters )

    % Finds the best set of correspondences modelling the matches as
    % elements of a non-cooperative game, discarding outliers in a previous
    % selections step by descriptor likelihood matching.
    % Solution is found by means of the Evolutionary Stable Strategy solver.
    % 
    % Inputs:
    %    keyPointsScene1: (Nx4) matrix containing 3D keypoint coordinates + original scene vertex indices
    %    keyPointsScene2: (Mx4) keypoints matrix for second scene
    %    correspondences: (Px3) set of correspondences specifying keypoint index matches and covariance descriptor likelihood values
    %    parameters:      parameters structure
    % Returns:
    %    gameWinners:     (Px3) set of matching point id pairs + match confidence scores
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    if parameters.verbose
        initialTime = tic;
    end
    
    % Model game matches
    payoffMatrix = BuildCostMatrix( keyPointsScene1, keyPointsScene2, correspondences );    
    
    % Find the stable solution to the non-cooperative game
    gameSolution = ESSsolver( payoffMatrix );    
    
    % Remove under-threshold winners for added confidence
    solutionThreshold = parameters.gameSolutionThr * max( gameSolution );        
    gameWinners = [ correspondences( gameSolution > solutionThreshold, 1:2 ), gameSolution( gameSolution > solutionThreshold ) ]; 
 
    if parameters.verbose
        totalTime = toc( initialTime );
        display( [ 'Game Theory matching procedure - Solution found. Elapsed time = ', num2str( totalTime ) ] );
    end
end