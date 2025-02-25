function ptcell = importPtCloudFromCSV(filepath)
%z = csvread('C:\Users\wesle\Documents\PointPillars\lvxsample2.csv' , 1, 7);
    [Timestamp, X1, Y1, Z1, Reflectivity] = importfile(filepath , 2);
    hundredmsfactor = 100000000;
    fps = 23617;
    numberOfElements = numel(Timestamp);
    numberOfFrames = fix(numberOfElements / fps); 

%     for v = 1.0:1:numberOfFrames
%         points = [X1((v-1)*(fps)+1:v*fps),Y1((v-1)*(fps)+1:v*fps),Z1((v-1)*(fps)+1:v*fps)];
%         ptCloud = pointCloud(points, 'Intensity' , Reflectivity((v-1)*(fps)+1:v*fps));
%         ptcell{v,1} = ptCloud; 
%     end
    chunkTime = Timestamp(1);
    ptInFrameCount = 1;
    frameMember = 1;
    points = zeros(100, 3); 
    reflex = zeros(100, 1);
    for v = 1.0:1:numberOfElements
      if (abs(Timestamp(v) - chunkTime) < hundredmsfactor)
          points(ptInFrameCount,1:3) = [X1(v) Y1(v), Z1(v)];
          reflex(ptInFrameCount,1) = [Reflectivity(v)];
          ptInFrameCount = ptInFrameCount + 1;
      else
         ptCloud = pointCloud(points, 'Intensity', reflex);
         ptcell{frameMember, 1} = ptCloud;
         ptInFrameCount = 1;
         frameMember = frameMember + 1;
         points = zeros(100, 3); 
         reflex = zeros(100, 1);
         chunkTime = Timestamp(v);
         disp(chunkTime);
         points(ptInFrameCount,1:3) = [X1(v), Y1(v), Z1(v)];
         reflex(ptInFrameCount,1) = [Reflectivity(v)];
         ptInFrameCount = ptInFrameCount + 1;
      end
      
    end
    
%     for v = 1.0:1:(numberOfFrames-1)
%         for k = v+1:1:numberOfFrames
%             if (ptcell{v,1} == ptcell{k,1})
%                 disp(k,v);
%             end
%         end
%     end
    
end

function [Timestamp, X1, Y1, Z1, Reflectivity] = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  [TIMESTAMP, X1, Y1, Z1, REFLECTIVITY] = IMPORTFILE(FILENAME) reads
%  data from text file FILENAME for the default selection.  Returns the
%  data as column vectors.
%
%  [TIMESTAMP, X1, Y1, Z1, REFLECTIVITY] = IMPORTFILE(FILE, DATALINES)
%  reads data for the specified row interval(s) of text file FILENAME.
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  [Timestamp, X1, Y1, Z1, Reflectivity] = importfile("C:\Users\wesle\Downloads\lvxsample2.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 13-Feb-2021 14:56:44

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 19);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Timestamp", "X1", "Y1", "Z1", "Reflectivity", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"];
opts.SelectedVariableNames = ["Timestamp", "X1", "Y1", "Z1", "Reflectivity"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
Timestamp = tbl.Timestamp;
X1 = tbl.X1;
Y1 = tbl.Y1;
Z1 = tbl.Z1;
Reflectivity = tbl.Reflectivity;
end

