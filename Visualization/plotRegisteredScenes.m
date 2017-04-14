function plotRegisteredScenes( scene1, scene2, R, T )

    % Plot registered scenes
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
    
    transfSc1 = R * [X1' ; Y1' ; Z1'];
    transfSc1 = transfSc1 + repmat(T,[1,size(transfSc1,2)]);
    
    figure;
    
    subplot(1,2,1),
    hold on;
    plot3(X2, Y2, Z2,'m.'); 
    plot3(transfSc1(1,:),transfSc1(2,:),transfSc1(3,:),'b.');
    axis image,
    view(3);
    grid on,
    xlabel('X'), ylabel('Y'), zlabel('Z');
    
    [rx, ry, rz] = GetEulerAngles(R);
    r = vrrotmat2vec(R); 
    title({ strcat('X-axis rotation degrees: ' , num2str(rx) , '  Y-axis rotation degrees: ' , num2str(ry), '  Z-axis rotation degrees: ' , num2str(rz)) ; ...
            strcat('Main rotation axis: [' , num2str(r(1)) , ',' , num2str(r(2)) , ',' , num2str(r(3)) , '] and angle: ' , num2str(rad2deg(r(4)))) ; ... 
            strcat('Translation: [' , num2str(T(1)) , ',' , num2str(T(2)) , ',' , num2str(T(3)) , ']')} , ...
            'FontSize' , 14);
    
    R1 = scene1.feats.R;
    G1 = scene1.feats.G;
    B1 = scene1.feats.B;

    R2 = scene2.feats.R;
    G2 = scene2.feats.G;
    B2 = scene2.feats.B;

    subplot(1,2,2),
    hold on;
    plot3rgb( [X2,Y2,Z2], [R2,G2,B2], 200, 25 ); 
    plot3rgb( transfSc1', [R1,G1,B1], 200, 25 );
    axis image,
    view(3);
    grid on,
    xlabel('X'), ylabel('Y'),zlabel('Z');      
end