function parameters = setupParameters()

    parameters.multiScaleRadius     = [1, 1.1, 1.3, 1.6, 2]; % Multi scale descriptor radii factors
    parameters.voxelSize            = 0.1;                   % Step factor for initial grid sampling of candidate keypoints
    parameters.nPointsVoxel         = 5;                     % Amount of points to sample in each grid voxel
    parameters.relevanceSampling    = true;                  % Use relevance sampling for extra keypoint saliency
    parameters.correspsModeSelector = 'rowDynamic';          % Selection mode for getting descriptor likelihood correspondences
                                                             % 'numFix':        selects a specified amount of candidate matches
                                                             % 'dynamic':       selects candidate matches under a global scene threshold
                                                             % 'rowDynamic':    selects candidate matches under an adapted threshold for each possible match
                                                             % 'relativeRatio': selects candidate matches if the difference between the best and the second best likelihood is greater than a certain threshold
    parameters.correspsThr          = 0.05;                  % Threshold value for correspondences selection: integer for 'numFix' mode, double for a factor in the other modes
    parameters.nMaxCorrespondences  = 2000;                  % Limit the amount of descriptor correspondences
    parameters.gameSolutionThr      = 0.5;                   % Threshold ratio for selecting the best Game Theory solution candidates
    parameters.verbose              = true;                  % Verbose results (show elapsed times, plot registration figures)
    
end



