function x = ESSsolver( C )

    % Computes the Evolutionary Stable Solution with guaranteed assimptotic convergence
    % given a game cost matrix
    % 
    % Implementation based on the method described in
    %  Albarelli, A., Bulo, S. R., Torsello, A., & Pelillo, M.
    %  "Matching as a non-cooperative game."
    %  In ICCV 2009 (pp. 1319-1326). IEEE.
    %
    % x = ESSsolver( C )
    %    C - (NxN), cost matrix for accounted game modelled matches
    % Returns:
    %    x - (Nx1), support vector indicating weighted game winners
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks : Yashin Dicente Cid, Xavier Mateo

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    N = size( C, 1 );
    x = ones( N, 1 )/N;
    xPrev = x;
    
    maxCPUtime = 180;   % safety CPU time assignation ( 180 seconds )
    minESSelements = 3; % safety number of elements to keep in the stable solution
    
    t = tic;
    while 1 && toc(t) < maxCPUtime
        
        % Compute game payoff for the current support game matches
        support = find( x > 0 );
        payoff = x' * C * x;
        Cx = C * x;
        
        % "Infection" phase, get set of positive and negative members
        tauPos = find( Cx > payoff );
        tauNeg = find( Cx < payoff );
        
        % Maximize population infection
        maxVals = zeros( N, 1 );
        maxVals( tauPos ) = Cx( tauPos ) - payoff;
        maxVals( intersect( support, tauNeg )) = -Cx( intersect( support, tauNeg )) + payoff;
        [~, Mx] = max( maxVals );
        
        % Update game dynamics with new population
        ei = zeros( N, 1 );
        ei( Mx ) = 1;
        if ismember( Mx, tauPos )
            Sx = ei;
        elseif ismember( Mx, intersect( support, tauNeg ))
            Sx = ( x(Mx) / ( x(Mx)-1) ) * ( ei-x ) + x;
        else
            Sx = x;
        end
        
        deltaCond = ( Sx-x )' * C * ( Sx-x );
        if deltaCond < 0
            delta = min( 1, ( (x-Sx)' * C * x ) / deltaCond );
        else
            delta = 1;
        end
        
        % Update support vector
        x = delta * ( Sx-x ) + x;
        
        % Stop condition: support vector convergence
        if sum( (x>0) - (xPrev>0) ) == 0 && norm( x-xPrev, Inf ) < 100*eps
            break;
        end

        % Extra safety stop condition: keep at least M winners in the support vector        
        if numel( find( x>0 )) < minESSelements
            x = xPrev;
            break;
        end
        
        xPrev = x;
    end
    
    if toc(t) >= maxCPUtime
        display( 'ESSsolver break - Max CPU time reached' );
    end
end