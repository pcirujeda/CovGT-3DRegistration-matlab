function res = sortCols( mat, colCriterion )

    % Sorts matrix rows according to the values of a specified column
    %
    % Inputs:
    %    mat: (MxN) matrix
    %    colCriterion: column index to use in sort
    % Returns:
    %    res: sorted matrix
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    [~, inds] = sort( mat(:, colCriterion));
    res = mat(inds,:);
end