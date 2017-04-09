function [ R, T ] = SupportVectorBasedTransformation( keyPointsScene1, keyPointsScene2, gameWinners, parameters )

    % Obtains a rigid transformation mapping a set of points to another
    % given a weighted set of point matches obtained by ESS solver.
    % Transformation is found via a weighted absolute orientation solving
    % method.
    % 
    % Inputs:
    %    keyPointsScene1: (Nx4) matrix containing 3D keypoint coordinates + original scene vertex indices
    %    keyPointsScene2: (Mx4) keypoints matrix for second scene
    %    gameWinners:     (Px3) set of matching point ids + match confidence scores
    %    parameters:      parameters structure
    % Returns:
    %    R: (3x3) rotation matrix
    %    T: (3x1) translation vector
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    if parameters.verbose
        initialTime = tic;
    end

    scene1Coordinates = keyPointsScene1( gameWinners(:,1), 1:3 );
    scene2Coordinates = keyPointsScene2( gameWinners(:,2), 1:3 );
    matchingScores    = gameWinners( :,3 );

    [ R, T ] = WeightedAbsoluteOrientation( scene1Coordinates', scene2Coordinates', matchingScores' );
    
    if parameters.verbose
        totalTime = toc( initialTime );
        display( [ 'Game Theory based transformation computed. Elapsed time = ', num2str( totalTime ) ] );
    end
end