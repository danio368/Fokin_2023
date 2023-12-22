%% Reads "data" file and transorms it in independant cells gathered in Cells 
% data is a direct import of the csv file generated by Imaris, when exporting
% track results
% In Matlab, run the import tool, pick the .csv file containing the Imaris
% track results. Choose Output Type Matrix. Check that the matrix contains
% 9 columns: 'Position X', 'Position Y', 'Position Z', 'Unit', 'Category',
% 'Collection', 'Time', 'TrackID', 'ID'. Import. Rename to 'data'
 
%Time interval: specifies the real time interval between two acquisition,
%to compute speed.

if ~exist('time_interval', 'var')
    %prompt = "Enter time interval between acquisitions (in min)";
    %time_interval=input(prompt);
    time_interval=inputdlg('Enter time interval between acquisitions (in min)','Set Time Interval', [1 20],{'2'});
    time_interval=str2num(time_interval{1});
end


clear Cells i j deb length;
j=1;
i=1;
cell_begin=1;
Cells=[];

if (max(data(:,8)-1e9+1)>1)
    while i<length(data) % Decomposition of data into individual cells

        if (data(i+1,8)~=data(i,8) || i==length(data)-1); % If we change cell, run the following code ...
            if (i==length(data)-1);
                i=i+1;
            end
            Cells(j).coordinates=data(cell_begin:i,[1,2,3,7]);
            cells_length=size(Cells(j).coordinates); % Length of cell j
            cells_length=cells_length(1);


            Cells(j).name=data(i,8)-1e9+1; 
            % Substracts (1e9-1) to cells nuber to have its actual number 
            Cells(j).instant_displacement=Cells(j).coordinates(2:cells_length,[1,2,3,4])-Cells(j).coordinates(1:(cells_length-1),[1,2,3,4]);  
            % Calculation of displacement of each cells between two timepoints 
            % Also calculates time difference (col 4) because time step may not be constant as gaps may be allowed in tracking
            Cells(j).instant_displacement(1:cells_length-1,4)=Cells(j).instant_displacement(1:cells_length-1,4)*time_interval; 
            % Multiplication of the number of steps between two frame by the actual time interval in order to have a time in minutes
            Cells(j).instant_speed=Cells(j).instant_displacement(:,1:3)./[Cells(j).instant_displacement(:,4),Cells(j).instant_displacement(:,4),Cells(j).instant_displacement(:,4)]; 
            % Calculation of the instant speed by dividing instant displacement by the time interval

            cell_begin=i+1;
            j=j+1;
        end
        i=i+1;
    end
else
    Cells(1).coordinates=data(:,[1,2,3,7]);
    cells_length=size(Cells(1).coordinates); % length of the cell
    cells_length=cells_length(1);
    Cells(1).name=data(1,8)-1e9+1; 
    % Substracts (1e9-1) to cells nuber to have its actual number 
    Cells(1).instant_displacement=Cells(1).coordinates(2:cells_length,[1,2,3,4])-Cells(1).coordinates(1:(cells_length-1),[1,2,3,4]);  
    % Calculation of displacement of each cells between two timepoints 
    % Also calculates time difference (col 4) because time step may not be constant as gaps may be allowed in tracking
    Cells(1).instant_displacement(1:cells_length-1,4)=Cells(1).instant_displacement(1:cells_length-1,4)*time_interval; 
    % Multiplication of the number of steps between two frame by the actual time interval in order to have a time in minutes
    Cells(1).instant_speed=Cells(1).instant_displacement(:,1:3)./[Cells(1).instant_displacement(:,4),Cells(1).instant_displacement(:,4),Cells(1).instant_displacement(:,4)]; 
    % Calculation of the instant speed by dividing instant displacement by the time interval
    clear i j cell_begin cells_length;
end

for i=1:length(Cells)
    Cells(i).total_displacement=Cells(i).coordinates(end,[1,2,3])-Cells(i).coordinates(1,[1,2,3]);
end 
clear i


clear i j cells_length cell_begin;
