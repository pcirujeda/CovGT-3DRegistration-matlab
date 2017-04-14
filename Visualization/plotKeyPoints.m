function plotKeyPoints( scene, keyPoints, descriptorRadius, parameters )

    % Plot keypoints and a random descriptor regions
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
       
    figure,
    subplot(1,2,1)
    hold on
    plotScene( scene )
    plot3( keyPoints(:,1), keyPoints(:,2), keyPoints(:,3), 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'MarkerSize', 10 )
    title( ['Keypoints on ', scene.sceneName, '(', num2str( size( keyPoints,1 ) ), ')'] );

    randomPoint = randsample(1:numel(scene.feats.X), 1);
    subplot(1,2,2)
    plotCovarianceDescriptor( scene, randomPoint, descriptorRadius, parameters.multiScaleRadius );
    title( 'Random point descriptor region' );
end