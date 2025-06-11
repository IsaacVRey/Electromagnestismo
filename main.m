% MAIN: Simulación completa del campo magnético de un solenoide
clear
clc
clf

global pos_x pos_y pos_z vec_x vec_y num_espiras puntos_por_espira
global campo_magnitud_linea eje_z

% Ejecutar espiral
espiral();

% Ejecutar campo magnético
campo();

%Ejecutar tryectoria
Runge_kuta(); 
