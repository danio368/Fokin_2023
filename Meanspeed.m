%%Compute total net speed and mean instant speed for each cell

%Compute net speed for each cell (which is the net displacement of one cell divided by the duration of its track : it underestimates the actual speed)
for i=1:length(Cells)
    Cells(i).net_speed=norm(Cells(i).total_displacement)/((Cells(i).coordinates(end)-Cells(i).coordinates(1,4))*time_interval);
end

%Compute the mean instant speed for every cell, average of the norm of instant
%speed on every times
for i=1:length(Cells)
    length_cells=size(Cells(i).instant_speed);
    length_cells=length_cells(1);
    for j=1:length_cells
        Cells(i).instant_speed(j,4)=norm(Cells(i).instant_speed(j,1:3));
    end
    Cells(i).mean_instant_speed=mean(Cells(i).instant_speed(:,4));
end

clear i j length_cells
