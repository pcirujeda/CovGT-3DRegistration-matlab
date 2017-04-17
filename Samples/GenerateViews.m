% Read different noise variations of the Baboon scene, cut different views
% and store to OBJ files

scene1 = OBJtoScene( 'Samples/Baboon_n001.obj' );
scene1View1 = CutScene( scene1, 0.5, 0.1 );
SceneToOBJ( scene1View1, './Samples/Baboon_view1.obj' )

scene2 = OBJtoScene( 'Samples/Baboon_n003.obj' );
scene2View1 = CutScene( scene2, 0.6, 0.05 );
SceneToOBJ( scene2View1, './Samples/Baboon_view2.obj' )