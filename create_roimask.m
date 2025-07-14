function arr_mask = create_roimask(rois_struct,mask_size)
% CREATE_ROIMASK make a binary mask out of a Horos ROI
%   First, import the ROI into MATLAB using 'readrois_xml.m', then supply a
%   MASK_SIZE (1x3 vector of sizes)

% Create empty mask
arr_mask = zeros(mask_size);

% Pull out AP size (this direction we have to flip)
sz_ap = mask_size(2);

% Loop over slices
nsl = length(rois_struct);

for ss = 1:nsl

    slicenum = rois_struct(ss).Slice;

    % Pull out slice points
    slicepoints = rois_struct(ss).ROIPoints;
    
    % Define roi points in each direction
    roipoints_RL = slicepoints(:,1);
    roipoints_AP = sz_ap - slicepoints(:,2);

    % Close the loops
    roipoints_RL(end+1) = roipoints_RL(1);
    roipoints_AP(end+1) = roipoints_AP(1);

    % Define the limits of points that could be inside the mask
    lim_RL = floor(min(roipoints_RL)):ceil(max(roipoints_RL));
    lim_AP = floor(min(roipoints_AP)):ceil(max(roipoints_AP));

    % Combine them using meshgrid
    [mesh_RL, mesh_AP] = meshgrid(lim_RL,lim_AP);

    % Use INPOLYGON to list the points that are inside the grid
    inpoints = inpolygon(mesh_RL(:),mesh_AP(:),roipoints_RL,roipoints_AP);

    % Pull out the coordinates of the masked points
    mask_RL = mesh_RL(inpoints);
    mask_AP = mesh_AP(inpoints);

    % Loop through points and change them to 1s in the mask
    for pp = 1:length(mask_RL)

        arr_mask(mask_RL(pp),mask_AP(pp),slicenum) = 1;

    end % for pp = 1:length(mask_RL)
    
end % for ss = 1:nsl