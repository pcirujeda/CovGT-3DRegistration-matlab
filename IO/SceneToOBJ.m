function SceneToOBJ( scene, fileName )

    % Stores a scene structure into a pointcloud OBJ file
    %
    % Inputs:
    %    scene:    scene structure
    %    fileName: output OBJ file
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    % Parse scene vertices
    nVertices = size( scene.feats.idx, 1);
    for v = 1:nVertices
        fileContents{v} = [ 'vn ', num2str( scene.feats.nx(v), '%.6f' ), ' ', ...
                                   num2str( scene.feats.ny(v), '%.6f' ), ' ', ...
                                   num2str( scene.feats.nz(v), '%.6f' ), '\n', ...
                             'v ', num2str( scene.feats.X(v), '%.6f'), ' ', ...
                                   num2str( scene.feats.Y(v), '%.6f'), ' ', ...
                                   num2str( scene.feats.Z(v), '%.6f'), ' ', ...
                                   num2str( scene.feats.R(v)/255, '%.6f'), ' ', ...
                                   num2str( scene.feats.G(v)/255, '%.6f'), ' ', ...
                                   num2str( scene.feats.B(v)/255, '%.6f'), '\n' ]; 
    end
    
    % Tag the end of file with the scene name
    fileContents{ 2*nVertices + 1} = [ '# ', scene.sceneName ];
    
    % Write contents to file
    fid = fopen( fileName, 'w' );
    fprintf( fid, strcat( fileContents{:} ) );
    fclose( fid );
    
    disp( ['Scene ', scene.sceneName, ' written to ', fileName ] );
end