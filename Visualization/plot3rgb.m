function plot3rgb( coordinates, colors, colorLevels, pointSize )

    % Plots a colored 3D point cloud efficiently with a limited color palette
    %
    % Inputs:
    %    coordinates: (Nx3) pointcloud coordinates
    %    colors:      (Nx3) pointcloud vertex RGB values
    %    colorLevels: number of palette colors
    %    pointSize:   pixel size
    %
    % Author: Pol Cirujeda ( pol.cirujeda@upf.edu )
    % Thanks: Xavier Mateo
    %
    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    image = [];
    image(:,:,1) = colors(:,1);
    image(:,:,2) = colors(:,2);
    image(:,:,3) = colors(:,3);
    
    % Normalize color values if needed
    if max( max( max( image ) ) ) > 1
        image = image / 255;
    end
    
    % Index color palette to a limited amount of values
    [ newImage, imageMap ] = rgb2ind( image, colorLevels );
    
    % Plot pointcloud with respect to color palette values for efficiency
    hold on;
    for i = 0:colorLevels-1
        idxs = find( newImage == i );
        if ~isempty( idxs )
            plot3( coordinates( idxs, 1 ), coordinates( idxs, 2 ), coordinates( idxs, 3 ), '.', 'Color', imageMap( i+1, : ), 'MarkerSize', pointSize );        
        end 
    end
end