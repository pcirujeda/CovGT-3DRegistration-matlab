function correspondences = SelectCorrespondences( likelihoodMatrix, parameters )
    
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

    if parameters.verbose
        initialTime = tic;
    end

    selectThreshold = parameters.correspsThr;
    
    correspondences = [];    
    
    firstIter = 1;
    while firstIter || (size(correspondences,1) > parameters.nMaxCorrespondences && selectThreshold > eps)
        
        if firstIter == 0
            selectThreshold = selectThreshold * 0.8;
        end

        clear correspondences;
        
        if size(likelihoodMatrix,1) > size(likelihoodMatrix,2)
            correspondencesPrev = GetCorrespondences(likelihoodMatrix', parameters.correspsModeSelector, selectThreshold);
            correspondences(:,1) = correspondencesPrev(:,2);
            correspondences(:,2) = correspondencesPrev(:,1);
            correspondences(:,3) = correspondencesPrev(:,3);
        else
            correspondences = GetCorrespondences(likelihoodMatrix, parameters.correspsModeSelector, selectThreshold);
        end
        
        firstIter = 0;
    end
    
    if selectThreshold < eps &&  size(correspondences,1) > parameters.nMaxCorrespondences
        correspondences = correspondences(randsample(size(correspondences,1), parameters.nMaxCorrespondences), :);
    end
        
    if parameters.verbose
        totalTime = toc(initialTime);
        display(['Selected ', num2str(size(correspondences,1)), ' covariance descriptor correspondences. Elapsed time = ', num2str(totalTime)]);
    end
    
end

function correspondences = GetCorrespondences( distsMatrix, mode, n )

    % Returns a Nx3 matrix of covariance descriptor correspondences, including the triplets
    % {Sc1-Point-id, Sc2-Point-id, descriptor-distance}

    distsMatrix = distsMatrix/max(distsMatrix(:));
    
    correspondences = [];

    switch mode
        
        case 'numFix' 
            
            n = max(1, floor(n));
            
            for i = 1:size(distsMatrix, 1)
                [sortedDists, inds] = sort(distsMatrix(i,:), 'ascend');
                correspondences = [correspondences; repmat(i, n, 1), inds(1:n)', sortedDists(1:n)'];
            end
            
            
        case 'dynamic'
            
            minDist = min(distsMatrix(:));
            threshold = minDist * (1+n);
            
            ind = find(distsMatrix <= threshold);
            [f, c] = ind2sub(size(distsMatrix), ind);
            
            correspondences = sortCols([f, c, distsMatrix(ind)], 1);
            
            
        case 'rowDynamic'
            
            for i = 1:size(distsMatrix, 1)
                minDist = min(distsMatrix(i,:));
                threshold = minDist * (1+n);

                ind = find(distsMatrix(i,:) <= threshold);
                
                correspondences = [correspondences; repmat(i, numel(ind), 1), ind', distsMatrix(i,ind)'];
            end


        case 'relativeRatio'

            for i = 1:size(distsMatrix, 1)
                [sortedDists, inds] = sort(distsMatrix(i,:), 'ascend');
                if sortedDists(1)*n < sortedDists(2)
                    correspondences = [correspondences; i, inds(1), sortedDists(1)];
                end
            end
            


    end
   
end