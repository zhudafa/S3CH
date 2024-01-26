function [GTSRB_DATA, GTSRB_LABEL, GTSRB_NAME] = load_GTSRB(category_list, image_list, feature_name)
% feature name: e.g. 'HOG/HOG_01'
% image_list: e.g. 0:29
% category_list: e.g. 0:42
% usage: save features of each category to mat file
% for ii = 0:42
%     [GTSRB_DATA, GTSRB_LABEL, GTSRB_NAME] = load_GTSRB(ii, 0:29, 'HOG/HOG_01');
%     eval(['save Final_Training/HOG/HOG_01/' sprintf('%05d', ii) '.mat GTSRB_DATA GTSRB_LABEL GTSRB_NAME'])
% end

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
nimage_per_track = length(image_list);
ncategory = length(ntrack_per_category);
ntrack_per_category=cell2mat(ntrack_per_category);

nimage = sum(ntrack_per_category) * nimage_per_track;

GTSRB_DATA = zeros(feature_dim, nimage);
GTSRB_LABEL = zeros(1, nimage);
GTSRB_NAME = cell(1, nimage);

counter = 0;
for ii = 1:ncategory
    folder_name = sprintf('%05d', category_list(ii));
    folder_dir = fullfile(feature_dir, folder_name);
    for jj = 1:ntrack_per_category(ii)
        for kk = 1:nimage_per_track
            file_name = sprintf('%05d_%05d.txt', jj - 1, image_list(kk));
            file_path = fullfile(folder_dir, file_name);
            counter = counter + 1;
            GTSRB_DATA(:, counter) = textscan(file_path, '%f');
            GTSRB_NAME{counter} = [folder_name '/' file_name];
            GTSRB_LABEL(counter) = ii;
        end
    end
end
end