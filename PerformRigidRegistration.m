function [ R, T ] = PerformRigidRegistration( scene1, scene2, parameters )

    % Estimates a rigid transformation for pairwise 3D scene registration.
    % Uses Covariance Descriptors for pointcloud analysis, keypoint
    % extraction and point matching.
    % Refines match candidates by Evolutionary Stable Strategy Game Theory.
    % 
    % Full method is described in:
    %
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    scene1, scene2: structs for scenes as read by OBJtoScene( objFile )
    %    parameters:     struct of parameters as defined in setupParameters()
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
    
    % Select key-points over the scenes:
    [ keyPointsScene1, covDescrRadiusSc1 ] = SelectKeypoints( scene1, parameters );
    [ keyPointsScene2, covDescrRadiusSc2 ] = SelectKeypoints( scene2, parameters );
    covDescrRadius = min( covDescrRadiusSc1, covDescrRadiusSc2 );
    
    % Compute descriptors and likelihood matrix:
    descriptorsScene1 = ComputeDescriptors( scene1, keyPointsScene1, covDescrRadius, parameters );
    descriptorsScene2 = ComputeDescriptors( scene2, keyPointsScene2, covDescrRadius, parameters );
    descriptorLikelihoodsMatrix = ComputeDescriptorLikelihoods( descriptorsScene1, descriptorsScene2, parameters );
    
    % Filter candidate correspondences:
    descriptorCorrespondences = SelectCorrespondences( descriptorLikelihoodsMatrix, parameters );
    
    % Best geometric consistent matching and transformation estimation:
    gameWinners = FindGameTheoryCorrespondences( keyPointsScene1, keyPointsScene2, descriptorCorrespondences, parameters );
    [ R, T ] = SupportVectorBasedTransformation( keyPointsScene1, keyPointsScene2, gameWinners, parameters );

    % Verbose results
    if parameters.verbose
	    totalTime = toc(initialTime);
        display(['Rigid registration finished. Total time = ', num2str(totalTime)]);
        
        close all
        
        % Plot the selected keypoints
        plotKeyPoints( scene1, keyPointsScene1, covDescrRadius, parameters );
        plotKeyPoints( scene2, keyPointsScene2, covDescrRadius, parameters );

        % Plot descriptor correspondent points
        figure,
        subplot(2,3,[1,4])
        plotCorrespondences( scene1, scene2, keyPointsScene1, keyPointsScene2, descriptorCorrespondences, [] );
        title( ['Covariance descriptor correspondences (', num2str(size(descriptorCorrespondences,1)), ')'] );

        % Plot Game Theory filtered matches
        subplot(2,3,[2,5])
        plotCorrespondences( scene1, scene2, keyPointsScene1, keyPointsScene2, [], gameWinners );
        title( ['Game Theory winner correspondences (', num2str(size(gameWinners,1)), ')'] );

        % Plot matching 3D geometric structures
        pointsSc1toSc2 = R * keyPointsScene1(:,1:3)';
        pointsSc1toSc2 = pointsSc1toSc2 + repmat( T, [1,size(keyPointsScene1,1)] );

        subplot(2,3,3)
        plotPointsStructure( pointsSc1toSc2', gameWinners(:,1) );
        title( 'Scene1 geometrical structure manifold' );

        subplot(2,3,6)
        plotPointsStructure( keyPointsScene2, gameWinners(:,2) );
        title( 'Scene2 geometrical structure manifold' );
        
        % Plot registered scenes
        plotRegisteredScenes( scene1, scene2, R, T );
    end
end