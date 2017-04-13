function inds = GridSamplePoints( coordinatesWithDeterminant, parameters)
    
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.    
    
    inds = [];
    
    rangeX = max(coordinatesWithDeterminant(:,1)) - min(coordinatesWithDeterminant(:,1));
    rangeY = max(coordinatesWithDeterminant(:,2)) - min(coordinatesWithDeterminant(:,2));
    rangeZ = max(coordinatesWithDeterminant(:,3)) - min(coordinatesWithDeterminant(:,3));
    
    sampleStepX = rangeX * parameters.voxelSize;
    sampleStepY = rangeY * parameters.voxelSize;
    sampleStepZ = rangeZ * parameters.voxelSize;
    
    gridX = min(coordinatesWithDeterminant(:,1)) : sampleStepX : max(coordinatesWithDeterminant(:,1));
    gridY = min(coordinatesWithDeterminant(:,2)) : sampleStepY : max(coordinatesWithDeterminant(:,2));
    gridZ = min(coordinatesWithDeterminant(:,3)) : sampleStepZ : max(coordinatesWithDeterminant(:,3));
    
    maxDet = max(coordinatesWithDeterminant(:,4));
    thrDet = maxDet * 1E-6;

    for i = 1:numel(gridX)-1
        idX = find(coordinatesWithDeterminant(:,1) > gridX(i) & coordinatesWithDeterminant(:,1) < gridX(i+1) & coordinatesWithDeterminant(:,4) > thrDet);
        for j = 1:numel(gridY)-1
            idY = find(coordinatesWithDeterminant(:,2) > gridY(j) & coordinatesWithDeterminant(:,2) < gridY(j+1) & coordinatesWithDeterminant(:,4) > thrDet);
            for k = 1:numel(gridZ)-1
                
                voxelInds = mintersect(idX, idY, find(coordinatesWithDeterminant(:,3) > gridZ(k) & coordinatesWithDeterminant(:,3) < gridZ(k+1) & coordinatesWithDeterminant(:,4) > thrDet));
                
                numKeyPointsVoxel = min(parameters.nPointsVoxel, numel(voxelInds));
                [~, detsVoxelInd] = sort(coordinatesWithDeterminant(voxelInds, 4), 'descend');
                inds = [inds; voxelInds(detsVoxelInd(1:numKeyPointsVoxel))];
            end
        end
    end
end
