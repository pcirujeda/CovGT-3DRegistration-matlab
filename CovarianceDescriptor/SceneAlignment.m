function [ alignedScene, rotation ] = SceneAlignment( scene )

    % Aligns a scene with respect to its principal axis
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    sceneCoordinates = [ scene.feats.X, scene.feats.Y, scene.feats.Z ];
    rotation = pca( sceneCoordinates );
    alignedScene = TransformScene( scene, rotation', [0;0;0] );
end