function scene = OBJtoScene( fileName, expandColorRange )

    % Reads an OBJ scene file containing vertex coordinates, color values
    % and normal vectors
    %
    % Inputs:
    %    fileName:         OBJ file
    %    expandColorRange: boolean flag. If set to 1 (default), expands color values to [0-255] range 
    % Returns:
    %    scene: scene structure
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
 
    if ~exist( 'expandColorRange', 'var' )
        expandColorRange = 1;
    end
    
    nx = [];
    ny = [];
    nz = [];
    X  = [];
    Y  = [];
    Z  = [];
    R  = [];
    G  = []; 
    B  = [];
    
    % Read file contents
    fid = fopen( fileName, 'r' );
    [~, sceneName] = fileparts( fileName ); 

    s = textscan( fid, '%s', 'Delimiter', '\n' );
    s = s{1};
    
    % Parse lines
    for i = 1:size(s,1)
        tline = s{i};
    
        if length( tline ) < 2 % blank line or comment
            continue;
            
        elseif strcmp( tline(1:2), 'vn' ) == 1 % normal vector
            temp = textscan( tline, '%s %f %f %f' );
            nx = [nx; temp{2}];
            ny = [ny; temp{3}];
            nz = [nz; temp{4}];
            
        elseif strcmp( tline(1:2), 'v ' ) == 1 % vertex
            temp = textscan( tline, '%s %f %f %f %f %f %f' ); 
            X = [X; temp{2}];
            Y = [Y; temp{3}];
            Z = [Z; temp{4}];
            R = [R; temp{5}];
            G = [G; temp{6}];
            B = [B; temp{7}];
        end            
    end
    fclose(fid); 

    % Create scene structure with all features
    scene.sceneName = sceneName;
    scene.feats.X  = X;
    scene.feats.Y  = Y;
    scene.feats.Z  = Z;
    scene.feats.nx = nx;
    scene.feats.ny = ny;
    scene.feats.nz = nz;
    scene.feats.idx = ( 1:numel( scene.feats.X ) )';

    if expandColorRange
        scene.feats.R = R*255;
        scene.feats.G = G*255;
        scene.feats.B = B*255;
    else
        scene.feats.R = R;
        scene.feats.G = G;
        scene.feats.B = B;
    end
end