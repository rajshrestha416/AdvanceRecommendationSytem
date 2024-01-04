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
disp(outputValues);
 
disp(['Heater Power: ', num2str(outputValues(1))]);
disp(['Lightning: ', num2str(outputValues(2))]);
disp(['Alarm: ', num2str(outputValues(3))]);
 
[~, heaterPowerRuleIndex] = max(outputValues(1));
[~, LightiningRuleIndex] = max(outputValues(2));
[~, AlarmRuleIndex] = max(outputValues(3));
 
disp(['Triggered Heater Power Rule: ', num2str(heaterPowerRuleIndex)]);
disp(['Triggered Lightining Rule: ', num2str(LightiningRuleIndex)]);
disp(['Triggered Speaker Rule: ', num2str(AlarmRuleIndex)]);
 
figure;
subplot(4, 1, 1);
plotmf(fis, 'input', 1);
title('Membership Functions for Temperature');
set(gca, 'XTick', [0 10 20]); 

subplot(4, 1, 2);
plotmf(fis, 'input', 2);
title('Membership Functions for Humidity');
set(gca, 'XTick', [0 60 70]);
 
 
subplot(4, 1, 3);
plotmf(fis, 'input', 3);
title('Membership Functions for Motion');
set(gca, 'XTick', [0 120 130]); 

subplot(4, 1, 4);
plotmf(fis, 'input', 4);
title('Membership Functions for Audio');
set(gca, 'XTick', [0 170 180]); 
% Set the renderer property to 'painters'
set(gcf, 'Renderer', 'painters');
% Plot output membership functions
figure;
subplot(3, 1, 1);
plotmf(fis, 'output', 1);
title('Output Membership Functions for Heater Power');
 
subplot(3, 1, 2);
plotmf(fis, 'output', 2);
title('Output Membership Functions for LightSystem');

subplot(3, 1, 3);
plotmf(fis, 'output', 3);
title('Output Membership Functions for Alarm');
 
% Set the renderer property to 'painters'
set(gcf, 'Renderer', 'painters');
 
figure;
plotfis(fis);
title('Defuzzification Process');
 
% Set the renderer property to 'painters'
set(gcf, 'Renderer', 'painters');
 
showrule(fis)

ruleview(fis)