function transformedScene = TransformScene( scene, R, T )

    % Applies a rigid transformation to a scene structure
    %
    % Inputs:
    %    scene: scene structure 
    %    R:     (3x3) rotation matrix
    %    T:     (1x3) translation vector
    % Returns:
    %    transformedScene: transformed scene structure
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    sceneCoordinates = [scene.feats.X,  scene.feats.Y,  scene.feats.Z];
    sceneNormals = [scene.feats.nx, scene.feats.ny, scene.feats.nz];
    
    txSceneCoordinates = ( sceneCoordinates * R' ) + repmat( T', [ size( sceneCoordinates, 1 ), 1 ] );
    txSceneNormals = sceneNormals * R';
    
    transformedScene          = scene;
    transformedScene.feats.X  = txSceneCoordinates(:,1);
    transformedScene.feats.Y  = txSceneCoordinates(:,2);
    transformedScene.feats.Z  = txSceneCoordinates(:,3);
    transformedScene.feats.nx = txSceneNormals(:,1);
    transformedScene.feats.ny = txSceneNormals(:,2);
    transformedScene.feats.nz = txSceneNormals(:,3);

end