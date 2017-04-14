function plotCorrespondences( scene1, scene2, pointsScene1, pointsScene2, correspondences, gameWinners )
  
    % Plot correspondences between two scenes
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.
    
    X1 = scene1.feats.X;
    Y1 = scene1.feats.Y;
    Z1 = scene1.feats.Z;    
    
    X2 = scene2.feats.X;
    Y2 = scene2.feats.Y;
    Z2 = scene2.feats.Z;
    
    meanXYZ1 = mean([X1, Y1, Z1]);
    meanXYZ2 = mean([X2, Y2, Z2]);
    
    scale = max([max(X1) - min(X1), max(Y1) - min(Y1), max(Z1) - min(Z1), ...
                 max(X2) - min(X2), max(Y2) - min(Y2), max(Z2) - min(Z2)]);
              
	X1 = (X1 - meanXYZ1(:,1)) / scale;
    Y1 = (Y1 - meanXYZ1(:,2)) / scale;
    Z1 = (Z1 - meanXYZ1(:,3)) / scale;
    
	X2 = (X2 - meanXYZ2(:,1)) / scale;
    Y2 = (Y2 - meanXYZ2(:,2)) / scale;
    Z2 = (Z2 - meanXYZ2(:,3)) / scale;
    
    pointsScene1 = [pointsScene1(:,1) - meanXYZ1(:,1), pointsScene1(:,2) - meanXYZ1(:,2), pointsScene1(:,3) - meanXYZ1(:,3)]/ scale;
    pointsScene2 = [pointsScene2(:,1) - meanXYZ2(:,1), pointsScene2(:,2) - meanXYZ2(:,2), pointsScene2(:,3) - meanXYZ2(:,3)]/ scale;
    
    yDisp    = -2;
    textDisp = 0.1;
    
    if size(correspondences, 1) > 0 && size(gameWinners, 1) > 0
        % Subplot covariance descriptor matches
        subplot(1,2,1);
    end
    
    if size(correspondences, 1) > 0
        hold on;
        plot3rgb( [X1, Y1, Z1], [scene1.feats.R, scene1.feats.G, scene1.feats.B], 200, 25);
        plot3rgb( [X2, Y2 + yDisp, Z2], [scene2.feats.R, scene2.feats.G, scene2.feats.B], 200, 25);

        maxWeight = max(correspondences(:,3));
        
        for i = 1:size(correspondences, 1)
            m = correspondences(i,1:2);
            color = [1-(correspondences(i,3)/maxWeight), correspondences(i,3)/maxWeight,  0];
            line([pointsScene1(m(1),1), pointsScene2(m(2),1)], [pointsScene1(m(1),2), pointsScene2(m(2),2) + yDisp], [pointsScene1(m(1),3), pointsScene2(m(2),3)], 'Color', 'r', 'LineWidth', 1);            
        end 
        hold off
    end
    
    if size(correspondences, 1) > 0 && size(gameWinners, 1) > 0
        % Subplot consistency game theory matches
        subplot(1,2,2);    
    end
    
    if size(gameWinners, 1) > 0
        hold on;
        plot3rgb( [X1, Y1, Z1], [scene1.feats.R, scene1.feats.G, scene1.feats.B], 200, 25);
        plot3rgb( [X2, Y2 + yDisp, Z2], [scene2.feats.R, scene2.feats.G, scene2.feats.B], 200, 25);

        maxWeight = max(gameWinners(:,3));

        for i = 1:size(gameWinners,1)
            m = gameWinners(i,1:2);
            color = [1-(gameWinners(i,3)/maxWeight), gameWinners(i,3)/maxWeight, 0];

            line([pointsScene1(m(1),1), pointsScene2(m(2),1)], [pointsScene1(m(1),2), pointsScene2(m(2),2) + yDisp], [pointsScene1(m(1),3), pointsScene2(m(2),3)], 'Color', 'r', 'LineWidth', 2);  

            plot3(pointsScene1(m(1),1), pointsScene1(m(1),2), pointsScene1(m(1),3),'o','MarkerFaceColor',color,'MarkerSize',15);
            plot3(pointsScene2(m(2),1), pointsScene2(m(2),2) + yDisp, pointsScene2(m(2),3),'o','MarkerFaceColor',color,'MarkerSize',15);

            text(pointsScene1(m(1),1)+textDisp, pointsScene1(m(1),2)+textDisp, pointsScene1(m(1),3)+textDisp, num2str(m(1)), 'BackgroundColor',color, 'FontWeight', 'demi');
            text(pointsScene2(m(2),1)+textDisp, pointsScene2(m(2),2)+textDisp+yDisp, pointsScene2(m(2),3)+textDisp, num2str(m(2)),'BackgroundColor',color, 'FontWeight', 'demi');
            
        end 
    end
    
end