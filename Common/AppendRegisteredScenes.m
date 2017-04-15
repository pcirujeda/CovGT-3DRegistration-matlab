function scene = AppendRegisteredScenes( sourceScene, targetScene, R, T )

    % Apply transformation to sourceScene and merge it with targetScene
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    transformedSourceScene = TransformScene( sourceScene, R, T );
    
    scene.feats.X = [ transformedSourceScene.feats.X; targetScene.feats.X ];
    scene.feats.Y = [ transformedSourceScene.feats.Y; targetScene.feats.Y ];
    scene.feats.Z = [ transformedSourceScene.feats.Z; targetScene.feats.Z ];
   
    scene.feats.nx = [ transformedSourceScene.feats.nx; targetScene.feats.nx ];
    scene.feats.ny = [ transformedSourceScene.feats.ny; targetScene.feats.ny ];
    scene.feats.nz = [ transformedSourceScene.feats.nz; targetScene.feats.nz ];
    
    scene.feats.R = [ transformedSourceScene.feats.R; targetScene.feats.R ];
    scene.feats.G = [ transformedSourceScene.feats.G; targetScene.feats.G ];
    scene.feats.B = [ transformedSourceScene.feats.B; targetScene.feats.B ];
    
    scene.feats.idx = ( 1:numel( scene.feats.X ) )';
    
    scene.sceneName = [ transformedSourceScene.sceneName, '_', targetScene.sceneName ];

end