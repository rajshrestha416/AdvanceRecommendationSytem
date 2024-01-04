% PART 1
% Fuzzy Init
fis = mamfis('Name', 'Intelligence Flat');
 
% Input
fis = addInput(fis, [0 100],'Name', 'Temperature');
fis = addInput(fis,[0 100], 'Name', 'Humidity');
fis = addInput(fis,[0 1], 'Name', 'PersonMotion');
fis = addInput(fis,[0 100], 'Name', 'Audio');
 
% Output
fis = addOutput(fis,[0 100],'Name', 'Heater');
fis = addOutput(fis,[0 1],'Name', 'LightSystem');
fis = addOutput(fis,[0 100],'Name', 'Alarm');
 
% Trimf membership functions
% Triangular membership functions with adjusted ranges and values
fis = addMF(fis, 'Temperature', 'trimf', [0 10 20], 'Name', 'cool');
fis = addMF(fis, 'Temperature', 'trimf', [15 25 35], 'Name', 'moderate');
fis = addMF(fis, 'Temperature', 'trimf', [30 40 50], 'Name', 'warm');

fis = addMF(fis, 'Humidity', 'trimf', [0 10 20], 'Name', 'low');
fis = addMF(fis, 'Humidity', 'trimf', [15 50 85], 'Name', 'average');
fis = addMF(fis, 'Humidity', 'trimf', [80 90 100], 'Name', 'high');

fis = addMF(fis, 'PersonMotion', 'trimf', [0 0.25 0.5], 'Name', 'minimal');
fis = addMF(fis, 'PersonMotion', 'trimf', [0.5 0.75 1], 'Name', 'active');

fis = addMF(fis, 'Audio', 'trimf', [0 10 20], 'Name', 'quiet');
fis = addMF(fis, 'Audio', 'trimf', [15 35 55], 'Name', 'medium');
fis = addMF(fis, 'Audio', 'trimf', [50 75 100], 'Name', 'loud');

fis = addMF(fis, 'Heater', 'trimf', [0 10 20], 'Name', 'low');
fis = addMF(fis, 'Heater', 'trimf', [15 40 65], 'Name', 'moderate');
fis = addMF(fis, 'Heater', 'trimf', [60 80 100], 'Name', 'high');

fis = addMF(fis, 'LightSystem', 'trimf', [0 0.25 0.5], 'Name', 'Dimmed');
fis = addMF(fis, 'LightSystem', 'trimf', [0.5 0.75 1], 'Name', 'Bright');

fis = addMF(fis, 'Alarm', 'trimf', [0 10 20], 'Name', 'soft');
fis = addMF(fis, 'Alarm', 'trimf', [15 35 55], 'Name', 'moderate');
fis = addMF(fis, 'Alarm', 'trimf', [50 75 100], 'Name', 'loud');


% Add rules
% Adjusting the rules to reflect the new membership function values
fis = addRule(fis, 'Temperature==cool & Humidity==high => Heater==high');
fis = addRule(fis, 'Temperature==warm & Humidity==low => Heater==low');
fis = addRule(fis, 'PersonMotion==active => LightSystem==Bright');
fis = addRule(fis, 'PersonMotion==minimal => LightSystem==Dimmed');
fis = addRule(fis, 'Audio==quiet => Alarm==soft');
fis = addRule(fis, 'Audio==medium => Alarm==moderate');
fis = addRule(fis, 'Audio==loud => Alarm==loud');


inputValues = [5,4,0,50];


outputValues = evalfis(fis, inputValues);
% PART 3

% particleswarm
% Define the objective function to maximize Alarm
disp("Particle Swarn....")
objectiveFunction = @(inputValues) -outputValues(3);

% Particle Swarm Optimization options
options = optimoptions('particleswarm', 'SwarmSize', 50, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for Temperature, Humidity, PersonMotion, Audio
ub = [100, 100, 1, 100];  % Upper bounds for Temperature, Humidity, PersonMotion, Audio

% Run Particle Swarm Optimization
[inputOptimal, objectiveOptimal] = particleswarm(objectiveFunction, 4, lb, ub, options);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Speaker Volume: ', num2str(-objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal(1))]);
disp(['Optimal LightSystem: ', num2str(outputOptimal(2))]);
disp(['Optimal Speaker Volume: ', num2str(outputOptimal(3))]);

outputvalue = evalfis(fis, inputValues)

disp("Pattern Search....")
% pattern search
% Define the objective function to maximize Alarm
objectiveFunction = @(inputValues) -outputvalue(3);

% Pattern Search options
options = optimoptions('patternsearch', 'InitialMeshSize', 10, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for Temperature, Humidity, PersonMotion, Audio
ub = [100, 100, 1, 100];  % Upper bounds for Temperature, Humidity, PersonMotion, Audio

% Run pattern search
inputOptimal = patternsearch(objectiveFunction, zeros(4,1), [], [], [], [], lb, ub, [], options);
objectiveOptimal = -objectiveFunction(inputOptimal);

% Display results
disp('Optimal Input Values: ');
disp(inputOptimal);

disp(['Optimal Speaker Volume: ', num2str(objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal(1))]);
disp(['Optimal Lightning: ', num2str(outputOptimal(2))]);
disp(['Optimal Speaker Volume: ', num2str(outputOptimal(3))]);
