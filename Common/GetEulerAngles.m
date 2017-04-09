function [ rx, ry, rz ]= GetEulerAngles( R )

    % Gets the rotation along x, y and z axis given a 3D rotation matrix
    % 
    % Implementation of the methods described in
    %  Pol Cirujeda, Yashin Dicente Cid, Xavier Mateo, Xavier Binefa
    %  "A 3D Scene Registration Method via Covariance Descriptors and an Evolutionary Stable Strategy Game Theory Solver"
    %  In IJCV 2015. IEEE.
    %
    % Inputs:
    %    R: (3x3) rotation matrix
    % Returns:
    %    rx: Rotation in x axis in radians
    %    ry: Rotation in y axis in radians
    %    rz: Rotation in z axis in radians
    %
    % Author : Pol Cirujeda ( pol.cirujeda@upf.edu )

    % Copyright notice: You are free to modify, extend and distribute 
    %    this code granted that the author of the original code is 
    %    mentioned as the original author of the code.

    % R = 
    % [                           cos(ry)*cos(rz),                          -cos(ry)*sin(rz),          sin(ry)]
    % [ cos(rx)*sin(rz) + cos(rz)*sin(rx)*sin(ry), cos(rx)*cos(rz) - sin(rx)*sin(ry)*sin(rz), -cos(ry)*sin(rx)]
    % [ sin(rx)*sin(rz) - cos(rx)*cos(rz)*sin(ry), cos(rz)*sin(rx) + cos(rx)*sin(ry)*sin(rz),  cos(rx)*cos(ry)]

    ry = asind( R(1,3) );
    rz = acosd( R(1,1)/cosd(ry) );
    rx = acosd( R(3,3)/cosd(ry) );
end