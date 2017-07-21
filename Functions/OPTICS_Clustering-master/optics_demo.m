% Brief Demo to Visualise Optics Results

% Written by Alex Kendall
% University of Cambridge
% 18 Feb 2015
% http://mi.eng.cam.ac.uk/~agk34/

% This software is licensed under GPLv3, see included glpv3.txt.

% ::IMPORTANT:: load your data to 'points'. Here is some example data:
load('example_data.mat');

points(10000:end,:)=[];

[ SetOfClusters, RD, CD, order ] = cluster_optics(points, minpts, epsilon);

x=[randn(30,2)*.4;randn(40,2)*.5+ones(40,1)*[4 4]];
[RD,CD,order]=optics(x,4)

bar(RD(order));
figure;

% Cycle through all clusters
for i=1:length(SetOfClusters)
    figure
    bar(RD(order(SetOfClusters(i).start:SetOfClusters(i).end)));
    pause(0.5)
end