addpath( genpath('./CovarianceDescriptor') );
addpath( genpath('./GameTheory') );
addpath( genpath('./Common') );
addpath( genpath('./IO') );
addpath( genpath('./Visualization') );
addpath( genpath('./Samples') );

% Read sample scene views
sourceScene = OBJtoScene( 'Samples/Baboon_view1.obj' );
targetScene = OBJtoScene( 'Samples/Baboon_view2.obj' );

% Perform registration
parameters = setupParameters();
[R, T] = PerformRigidRegistration( sourceScene, targetScene, parameters );

% Compose registered scene and store to file
registeredScene = AppendRegisteredScenes( sourceScene, targetScene, R, T );
SceneToOBJ( registeredScene, 'output.obj' );
