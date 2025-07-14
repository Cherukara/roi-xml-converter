function slice_data = readrois_xml(filename)
% READROIS_XML read in ROI values from an XML file and store as a MATLAB
% structure.
%
% Created by MT Cherukara, 2025-07-11
% All rights reserved

% Read in the primary tumour .xml
roi = parseXML(filename);


% roi is a 1x2 struct
%   roi(1) = nothing
%   roi(2) = info
% roi(2).Children is 1x3 struct
%   roi(2).Children(1) = nothing
%   roi(2).Children(2) = info
%   roi(2).Children(3) = nothing
% roi(2).Children(2).Children is a 1x5 struct
%   roi(2).Children(2).Children(1) = nothing
%   roi(2).Children(2).Children(2) = 'key' = 'ROI array'
%   roi(2).Children(2).Children(3) = nothing
%   roi(2).Children(2).Children(4) = 'array'
%   roi(2).Children(2).Children(5) = nothing
% roi(2).Children(2).Children(4).Children is a 1x41 struct
%   All of the "even" ones are 1x21 structs

slice_rois = roi(2).Children(2).Children(4).Children(2:2:end);
nslice = length(slice_rois);

% Create a structure that has 5 fields: DataSummary, DataValues, Name,
% ROIPoints, Slice
slice_data = struct('DataSummary',cell(1,nslice),...
                    'DataValues',cell(1,nslice),...
                    'Name',cell(1,nslice),...
                    'ROIPoints',cell(1,nslice),...
                    'Slice',cell(1,nslice));

% Loop through the slices and pull out a data structure
for ss = 1:nslice

    % Pull out the data for the current slice
    struct_slice = slice_rois(ss).Children(2:2:end);

    % Fill in the "Name" and "Slice" data (these are single entries)
    slice_data(ss).Name = struct_slice(6).Children.Data;
    slice_data(ss).Slice = str2double(struct_slice(10).Children.Data);

    % Put together Data Summary structure
    slice_ds = struct_slice(2).Children(2:2:end);
    nds = length(slice_ds)/2;

    % Loop through Data Summary elements and fill in a structure
    for ii = 1:nds

        struct_ds.(slice_ds((ii*2)-1).Children.Data) = str2double(slice_ds(ii*2).Children.Data);

    end % for ii = 1:nds
    
    % Assign this structure to the 'DataSummary' field
    slice_data(ss).DataSummary = struct_ds;

    % Pull together Data Values
    slice_dv = struct_slice(4).Children(2:2:end);
    ndv = length(slice_dv);

    % Pre-allocate a vector for Data Values
    vec_dv = zeros(ndv,1);

    for ii = 1:ndv
        vec_dv(ii) = str2double(slice_dv(ii).Children.Data);
    end

    % Assign this vector to the 'DataValues' field
    slice_data(ss).DataValues = vec_dv;

    % Pull together ROI Points
    slice_rp = struct_slice(8).Children(2:2:end);
    nrp = length(slice_rp);

    % Pre-allocate a matrix of ROI coordinates
    mat_roipoints = zeros(nrp,2);

    for ii = 1:nrp
        mat_roipoints(ii,:) = cell2mat(eval(slice_rp(ii).Children.Data));
    end

    % Assign this matrix to the 'ROIPoints' field
    slice_data(ss).ROIPoints = mat_roipoints;


end % for ss = 1:nslice
