function plotScene( scene )
    
    % Plot a given scene
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    plot3rgb( [ scene.feats.X, scene.feats.Y, scene.feats.Z], [scene.feats.R, scene.feats.G, scene.feats.B ], 200, 10 );
    grid on
    axis image;
    xlabel('X'), ylabel('Y'), zlabel('Z');      
    view(3)
    
end