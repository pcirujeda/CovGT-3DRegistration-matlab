function plotCovarianceDescriptor( scene, point, radius, scales )

    % Plot the region used when computing a given covariance descriptor
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    dists = dist( [ scene.feats.X(point), scene.feats.Y(point), scene.feats.Z(point) ], [ scene.feats.X, scene.feats.Y, scene.feats.Z ]' );

    hold on;
    plotScene( scene )
    
    % Plot different scale regions
    for sc = numel(scales):-1:1
        color = [1 0 0] + ([-sc 0 sc] / numel(scales));
        plot3( scene.feats.X( dists <= radius*scales(sc) ), scene.feats.Y( dists <= radius*scales(sc) ), scene.feats.Z( dists <= radius*scales(sc) ), '.', 'Color', color, 'MarkerSize', 15 );
    end
    
    % Highlight descriptor center
    plot3( scene.feats.X(point), scene.feats.Y(point), scene.feats.Z(point), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'g', 'MarkerSize', 18 );
    hold off
    
end