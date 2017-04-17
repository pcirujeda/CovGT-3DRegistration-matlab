function [ sceneA, sceneB ] = CutScene( scene, percentage, tolerance )

    % Slice a scene in two views. Used in testing
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    % Random Rotation
    r    = rand(1,4);
    rot  = RotationMat3D(r(1),[r(2),r(3),r(4)]);
    scene = TransformScene( scene, rot, [0;0;0] );

    rangeX = max(scene.feats.X) - min(scene.feats.X);
    rangeY = max(scene.feats.Y) - min(scene.feats.Y);
    rangeZ = max(scene.feats.Z) - min(scene.feats.Z);
    
    % 10% range slicing steps
    thrsX = min(scene.feats.X) : 0.1*rangeX : max(scene.feats.X);
    thrsY = min(scene.feats.Y) : 0.1*rangeY : max(scene.feats.Y);
    thrsZ = min(scene.feats.Z) : 0.1*rangeZ : max(scene.feats.Z);
    
    % Obtain a random sign in order to check positive or negative points wrt to plane
    planeSign = round(rand);
    
    iC = 1;
    for iX = randsample(thrsX, numel(thrsX))
        for iY = randsample(thrsY, numel(thrsY))
            for iZ = randsample(thrsZ, numel(thrsZ))
       
                if planeSign
                    cut = mintersect(find(scene.feats.X < iX), find(scene.feats.Y < iY), find(scene.feats.Z < iZ));
                else
                    cut = mintersect(find(scene.feats.X > iX), find(scene.feats.Y > iY), find(scene.feats.Z > iZ));
                end

                cuts(iC,:) = [numel(cut), iX, iY, iZ];
                iC         = iC+1;
                
            end
        end
    end

    % Get slices which contain a certain percentage (+/- tolerance) amount of scene points
    nPoints = numel(scene.feats.X);    
    idCut = find(cuts(:,1) > nPoints*(percentage-tolerance) & cuts(:,1) < nPoints*(percentage+tolerance));

    while isempty(idCut)
        tolerance = 2*tolerance;
        idCut = find(cuts(:,1) > nPoints*(percentage-tolerance) & cuts(:,1) < nPoints*(percentage+tolerance));
    end
    
    if planeSign
        idxA = mintersect(find(scene.feats.X < cuts(idCut(1),2)), find(scene.feats.Y < cuts(idCut(1),3)), find(scene.feats.Z < cuts(idCut(1),4)));
    else
        idxA = mintersect(find(scene.feats.X > cuts(idCut(1),2)), find(scene.feats.Y > cuts(idCut(1),3)), find(scene.feats.Z > cuts(idCut(1),4)));
    end
    
    idxB = setdiff([1:nPoints], idxA);
 
    % Compose scenes
    sceneA.sceneName = scene.sceneName;
    sceneA.feats.X = scene.feats.X(idxA);
    sceneA.feats.Y = scene.feats.Y(idxA);
    sceneA.feats.Z = scene.feats.Z(idxA);
    sceneA.feats.nx = scene.feats.nx(idxA);
    sceneA.feats.ny = scene.feats.ny(idxA);
    sceneA.feats.nz = scene.feats.nz(idxA);
    sceneA.feats.R = scene.feats.R(idxA);
    sceneA.feats.G = scene.feats.G(idxA);
    sceneA.feats.B = scene.feats.B(idxA);
    sceneA.feats.idx = scene.feats.idx(idxA);
    
    sceneB.sceneName = scene.sceneName;
    sceneB.feats.X = scene.feats.X(idxB);
    sceneB.feats.Y = scene.feats.Y(idxB);
    sceneB.feats.Z = scene.feats.Z(idxB);
    sceneB.feats.nx = scene.feats.nx(idxB);
    sceneB.feats.ny = scene.feats.ny(idxB);
    sceneB.feats.nz = scene.feats.nz(idxB);
    sceneB.feats.R = scene.feats.R(idxB);
    sceneB.feats.G = scene.feats.G(idxB);
    sceneB.feats.B = scene.feats.B(idxB);
    sceneB.feats.idx = scene.feats.idx(idxB);
    
end
