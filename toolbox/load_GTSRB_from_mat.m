function [GTSRB_DATA_ALL, GTSRB_LABEL_ALL, GTSRB_NAME_ALL] = load_GTSRB_from_mat(category_list, feature_name)
% feature name: e.g. 'HOG/HOG_01'
% category_list: e.g. 0:42

feature_dir = fullfile(fileparts(mfilename('fullpath')), 'Final_Training', feature_name);
if feature_name(end) == '1' || feature_name(end) == '2'
    feature_dim = 1568;
elseif feature_name(end) == '3'
    feature_dim = 2916;
else
    fprintf('Error: unable to determine feature dimension');
end

ntrack_per_category = textscan('GTSRB_info.dat', '%d');
ntrack_per_category = ntrack_per_category(category_list + 1);
nimage_per_track = 30;
ncategory = length(ntrack_per_category);

nimage = sum(ntrack_per_category) * nimage_per_track;

GTSRB_DATA_ALL = zeros(feature_dim, nimage);
GTSRB_LABEL_ALL = zeros(1, nimage);
GTSRB_NAME_ALL = cell(1, nimage);

counter = 0;
for ii = 1:ncategory
    folder_name = sprintf('%05d', category_list(ii));
    folder_dir = fullfile(feature_dir, folder_name);

    load([folder_dir, '.mat']);
    GTSRB_DATA_ALL(:, counter + [1:length(GTSRB_NAME)]) = GTSRB_DATA;
    GTSRB_NAME_ALL(counter + [1:length(GTSRB_NAME)]) = GTSRB_NAME;
    GTSRB_LABEL_ALL(counter + [1:length(GTSRB_NAME)]) = ii;
    counter = counter + length(GTSRB_NAME);
end
end