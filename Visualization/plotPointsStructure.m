function plotPointsStructure( points, gameWinners )

    % Plot a 3D geometrical structure of a point set
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.    

    gWpoints = points( gameWinners, : );
    textDisp = 0;
    
    %# all possible combinations of the elements of [1:N] taken 2 at a time
    pairs = nchoosek(1:size(gWpoints,1), 2)';

    % plot points and lines
    hold on;
    plot3(gWpoints(pairs,1), gWpoints(pairs,2), gWpoints(pairs,3), '-ro', 'MarkerFaceColor','g', 'MarkerSize',2, 'LineWidth', 2);
    text(gWpoints(:,1)+textDisp, gWpoints(:,2)+textDisp, gWpoints(:,3)+textDisp, num2str(gameWinners), 'BackgroundColor','g', 'FontWeight', 'demi');
    hold off;

end